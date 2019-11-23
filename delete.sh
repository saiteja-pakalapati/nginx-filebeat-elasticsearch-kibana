#!/usr/bin/env bash

# function to parse command line arguments
parse_args() {
    hard=false
    help=false
    for arg in "$@"
    do
        case $arg in
            --hard)
                hard=true
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
        echo "unknown option(s):$1"
        print_help
        exit 1;
    fi
}

#print help text on console
print_help(){
    echo "
    Usage: bash delete.sh [OPTIONS]

    A quick and easy filebeat,elasticsearch and kibana environment for learning using docker

    Options:
          --hard    Deletes the elasticsearch,filebeat and kibana docker images
          --help    Print the help text on console
    "
}

#function to delete  efk images
delete_images(){
    docker rmi -f elasticsearch:6.6.0
    docker rmi -f kibana:6.6.0
    docker rmi -f elastic/filebeat:6.6.0
}

#function to delete efk network
delete_network(){
    docker network rm  efk
}

#function to delete efk containers
delete_containers(){
    docker rm -f kibana
    docker rm -f filebeat
    docker rm -f elasticsearch
    docker rm -f nginx
}

#parse cli args
parse_args "$@"

#print help text
if [ $help = true ] ; then
    print_help
    exit 0
fi

#delete efk containers
delete_containers
delete_network

# perform hard reset if hard=true
if [ $hard = true ] ; then
    delete_images
fi