#!/bin/bash
##
# @Description: Steps to pass multiple parameters in shell script
# Take single argument
##

function show_usage (){
    printf "Usage: $0 [options [parameters]]\n"
    printf "\n"
    printf "Options:\n"
    printf " -u|--up, starts the container in detached mode\n"
    printf " -d|--drop drops the container\n"
    printf " -b|--build\n builds the container"
    return 0
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]];then
    show_usage
else
    echo "Processing request"
    # show_usage
fi

set -a
source .env
# or use a switch case instead
while [ ! -z "$1" ]; do
  case "$1" in
     --up|-u)
         shift
         echo "starting docker stack: $1"
         docker-compose up -d
         echo "following logs for socket"
         docker logs -f socketapp
         ;;
     --down|-d)
         shift
         echo "dropping docker stack: $1"
         docker-compose down
         ;;
     --build|-b)
        shift
        docker-compose build
        echo "building docker stack: $1"
         ;;
     *)
        show_usage
        ;;
  esac
shift
done



# https://www.golinuxcloud.com/how-to-pass-multiple-parameters-in-shell-script-in-linux/
# https://www.learningcrux.com/course/linux-bash-shell-scripting-complete-guide-incl-awk-sed
