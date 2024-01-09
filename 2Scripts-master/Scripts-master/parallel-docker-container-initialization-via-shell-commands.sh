function deploy_nginx_cluster() {
    docker pull centos
    sleep 15
    for idx in 1 2
    do
        parallelize "$idx" &
    done
}

function parallelize(){
        docker run -d --restart=always --name=centos$1 -p 808$1:80 centos/systemd:latest 
        docker exec -t centos$1 /bin/bash -c "yum -y update; yum -y install epel-release; yum -y install nginx; cd /usr/sbin; ./nginx"
}

deploy_nginx_cluster
