#!/usr/bin/env bash

# parse command line arguments
parse_args() {
    pull=false
    help=false
    for arg in "$@"
    do
        case $arg in
            --pull)
                pull=true
                shift # past argument=value
            ;;
            --help)
                help=true
                shift # past argument=value
            ;;
            *)
                # capture unkown options
            ;;
        esac
    done
    if [[ -n $1 ]]; then
        echo "unknown options(s):$1"
        print_help
        exit 1;
    fi
}

#print help text on console
print_help(){
    echo "
    Usage: bash create.sh [OPTIONS]

    A quick and easy filebeat,elasticsearch and kibana environment for learning using docker

    Options:
          --pull    Pull updated docker images from docker hub before starting the containers
          --help    Print the help text on console
    "
}
# pull efk stack docker images
pull_images(){
    echo "pulling elasticsearch:6.6.0,kibana:6.6.0,elastic/filebeat:6.6.0 and nginx:latest Docker images"
    docker pull elasticsearch:6.6.0
    docker pull kibana:6.6.0
    docker pull elastic/filebeat:6.6.0
    docker pull nginx:latest
}

# create network for efk containers
create_network(){
    echo "creating docker bridge network efk"
    docker network create \
    --driver=bridge \
    efk
}

# run containers
run_containers(){
    
    echo "creating elasticsearch container"
    docker run \
    -d \
    --name elasticsearch \
    --net efk \
    --publish 9200:9200 \
    --publish 9300:9300 \
    -e "discovery.type=single-node" \
    elasticsearch:6.6.0
    
    echo "creating kibana container"
    docker run \
    -d \
    --name kibana \
    --net efk \
    --publish 5601:5601 \
    --volume `pwd`/config/kibana.yml:/usr/share/kibana/config/kibana.yml \
    kibana:6.6.0
    
    echo "creating filebeat container"
    docker run \
    -d \
    --name filebeat \
    --net efk \
    --volume `pwd`/config/filebeat.yml:/usr/share/filebeat/filebeat.yml \
    --volume /tmp/nginx/:/tmp/nginx/ \
    elastic/filebeat:6.6.0
    
    echo "creating nginx container"
    # creating a directory to store logs this directory will be mounted to filebeat container
    mkdir -p /tmp/nginx
    docker run \
    -d \
    --name nginx \
    --volume /tmp/nginx:/var/log/nginx \
    --publish 9000:80 \
    --network efk \
    nginx:latest
}

# function to import dashboard
import_dashboard(){

    echo "creating the dashboard"
    sleep 120
    curl -s -o /dev/null -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" -d @./kibana/dashboard.json http://localhost:5601/api/kibana/dashboards/import

}

# function to export a dashboard
export_dashbord(){

    curl "localhost:5601/api/kibana/dashboards/export?dashboard=144be580-543c-11e9-93a6-b75c1f1a0bc2" > export.json

}

parse_args $@

if [ $help = true ] ; then
    print_help
    exit 0
fi
if [ $pull = true ] ; then
    echo "pulling latest docker images before staring the containers"
    pull_images
fi
create_network
run_containers
import_dashboard