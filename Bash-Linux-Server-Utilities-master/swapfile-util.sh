#!/bin/bash

# Common functions
print_separator() {
    echo -e "\033[36m-\033[94m===========================\033[36m-\033[39m"
}

print_header() {
    echo -e "          \033[36m_   \033[94m__  \033[36m_\033[39m"
    echo -e "     \033[96m_  \033[36m_// \033[94m/\\\\\\ \\ \033[36m\\\\\\_  \033[96m_ \033[39m"
    echo -e "   \033[96m_// \033[36m/ / \033[94m/ /_\\ \\ \033[36m\\ \\ \033[96m\\\\\\_ \033[39m"
    echo -e "  \033[96m/ / \033[36m/ / \033[94m/ ___\\\\\\ \\ \033[36m\\ \\ \033[96m\\ \\\ \033[39m"
    echo -e " \033[96m/_/ \033[36m/_/ \033[94m/_/     \033[94m\\_\\ \033[36m\\_\\ \033[96m\\_\\\ \033[39m"
    print_separator
    echo -e "\033[36m        NibblePoker's  \033[39m"
    echo -e "\033[36m      Swapfile Utility \033[39m"
    print_separator
}

print_footer() {
    print_separator
    echo -e " \033[96m\\_\\ \033[36m\\_\\             \033[36m/_/ \033[96m/_/\033[39m"
}

function prompt_yes_no {
    local message=$1
    while true; do
        read -p "$message" answer
        case $answer in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please enter yes or no.";;
        esac
    done
}


# Main code
print_header


# Root check
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[31mThis script must be run as root.\033[39m"
    print_footer
    exit 1
fi


# Program availability checks
echo "Checking availability of required programs..."
if which fallocate &> /dev/null; then
    echo -e "> \033[32mOK\033[39m - fallocate"
else
    echo -e "> \033[31mMISSING\033[39m - fallocate"
    print_footer
    exit 2
fi

if which mkswap &> /dev/null; then
    echo -e "> \033[32mOK\033[39m - mkswap"
else
    echo -e "> \033[31mMISSING\033[39m - mkswap"
    print_footer
    exit 3
fi

if which swapon &> /dev/null; then
    echo -e "> \033[32mOK\033[39m - swapon"
else
    echo -e "> \033[31mMISSING\033[39m - swapon"
    print_footer
    exit 4
fi

if which numfmt  &> /dev/null; then
    echo -e "> \033[32mOK\033[39m - numfmt "
else
    echo -e "> \033[31mMISSING\033[39m - numfmt "
    print_footer
    exit 4
fi

print_separator


# > Getting the swapfile's desired location
read -p "Swapfile location [/swapfile]: " swapfileLocation
swapfileLocation=${swapfileLocation:-/swapfile}

echo -e "> Using '\033[96m$swapfileLocation\033[39m'"

if [[ ! $swapfileLocation == /* ]]; then
    echo "The given path is not absolute !"
    exit 1
fi


# > Checking if the file already exist
if [ -f "$swapfileLocation" ]; then
    echo "> The swapfile already exist !"
    
    if prompt_yes_no "Do you want to delete it ? [Y/N]"; then
        # TODO: Remove it
        echo "TODO"
        exit 0
    else
        echo "> No action needs to be taken"
    fi
    
    print_footer
    exit 0
fi


# We ask the user for the desired swap size
print_separator

read -p "Swapfile size [1G]: " swapfileSize
swapfileSize=${swapfileSize:-1G}

echo -e "> Given size: '\033[96m$swapfileSize\033[39m'"
swapfileByteSize=$(numfmt --from=iec $swapfileSize)
echo -e "> Byte size: '\033[96m$swapfileByteSize\033[39m'"


# Checking if the mount point is valid
print_separator
echo "Checking the path & mount points..."

swapfileDirectory=$(dirname "$swapfileLocation")
echo -e "> Directory: '\033[96m$swapfileDirectory\033[39m'"

if mkdir -p $swapfileDirectory &> /dev/null; then
    echo -e "> The directory tree is available"
else
    echo -e "> \033[31mUnable to create the directory tree !MISSING\033[39m"
    print_footer
    exit 10
fi

swapfileDevice=$(df -P / | awk 'NR==2 {print $1}')
swapfileDeviceMount=$(df -P / | awk 'NR==2 {print $6}')

if [ -z "$swapfileDevice" ]; then
    echo -e "> \033[31mUnable to find the parent mount for '$swapfileDirectory' !\033[39m"
    print_footer
    exit 11
fi

if [ -z "$swapfileDeviceMount" ]; then
    echo -e "> \033[31mUnable to determine mount point for '$swapfileDevice' !\033[39m"
    print_footer
    exit 12
fi

echo -e "> Mount: '\033[96m$swapfileDeviceMount\033[39m' on '\033[96m$swapfileDevice\033[39m'"


# Checking if the drive has the required amount of space
print_separator
echo -e "Checking the available space on '\033[96m$swapfileDevice\033[39m'"

availableSpace=$(df -P / -B1 | awk 'NR==2 {print $4}')
availableSpaceHuman=$(df -P / -h | awk 'NR==2 {print $4}')

echo -e "> Available space on '\033[96m$swapfileDevice\033[39m':"
echo -e "> '\033[96m$availableSpaceHuman\033[39m' <-> '\033[96m$availableSpace\033[39m' bytes"

if (( $availableSpace > $swapfileByteSize )); then
    echo -e "> We have enough space :)"
else
    echo -e "> \033[31mNot enough space available to create the swapfile !\033[39m"
    print_footer
    exit 20
fi


# Asking the user to validate the commands
print_separator
echo -e "Please review and approve the commands that will be executed"
echo -e "$ \033[32mfallocate -l $swapfileByteSize $swapfileLocation\033[39m"
echo -e "$ \033[32mchmod 600 $swapfileLocation\033[39m"
echo -e "$ \033[32mmkswap $swapfileLocation\033[39m"
echo -e "$ \033[32mswapon $swapfileLocation\033[39m"

if prompt_yes_no "Does is all look good to you ? [Y/N]"; then
    echo "> Alrighty, starting the process..."
else
    echo "> No further action will to be taken !"
    echo "> Please report any issue to the project's repository."
    print_footer
    exit 0
fi


# Running the commands
echo "> Allocating swapfile..."
fallocate -l $swapfileByteSize $swapfileLocation

echo "> Setting up permissions..."
chmod 600 $swapfileLocation

echo "> Setting up the swap area..."
mkswap $swapfileLocation

echo "> Enabling the swapfile..."
swapon $swapfileLocation

exit 0


# Asking the user if they want to make it permanent
print_separator
echo -e "The swapfile can be made permanent by adding an entry to '/etc/fstab'."
echo -e "The following command will be used if you desire to:"
echo -e "$ \033[32mecho \"$swapfileLocation swap swap defaults 0 0\" >> /etc/fstab\033[39m"

if prompt_yes_no "Does is all look good to you ? [Y/N]"; then
    echo "> Alrighty, starting the process..."
    echo "$swapfileLocation swap swap defaults 0 0" >> /etc/fstab
else
    echo "> No further action will to be taken !"
fi


# We're done
print_separator
echo -e "We're finished :)"
echo -e "Thank you for using our script, have a good day."
print_footer
exit 0
