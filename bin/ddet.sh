#!/usr/bin/env bash

alpine=""
entryPoint=""
wantedVersion="latest"
volumeVersion="_7"

volumeComposer="composer${volumeVersion}"
volumeComposerCache="composer${volumeVersion}_cache"

#set -x

display_help () {
#    set +x

    echo "Developer Environment Tools"
    echo ""
    echo "USAGE: ddet CMD"
    echo ""
    echo "Possible commands"
    echo "    all     : Start all containers"
    echo "    adminer : Start the adminer container"
    echo "    init    : Initiates the environment, creating the Docker volumes"
    echo "              and networks."
    echo "    proxy   : Start the Nginx reverse proxy. Auto-started by some"
    echo "              other tools."
    echo "    status  : Show status of containers"
    echo ""
    echo ""

    return 0
}

init () {
    docker-compose -f ddet/docker-compose.yml up -d

    return 0
}

adminer () {
    reverse_proxy

    docker-compose -f ddet/docker-compose.adminer.yml up -d
}

docker_compose_ps () {
    docker-compose \
        -f ddet/docker-compose.yml \
        -f ddet/docker-compose.adminer.yml \
        ps
}

reverse_proxy () {
    docker-compose \
        -f ./reverse-proxy/docker-compose.yml \
        up -d

    return 0
}

while :
do
    case "$1" in
        adminer)
            adminer
            exit 0
        ;;
        all)
            reverse_proxy
            adminer
            docker_compose_ps
            exit 0
        ;;
        init)
            init
            exit 0
        ;;
        proxy)
            reverse_proxy
            exit 0
        ;;
        status)
            docker_compose_ps
            exit 0
        ;;
        -c | --cmd)
            entryPoint=$2
            shift 2;
        ;;
        -h | --help)
            display_help
            # no shifting needed here, we're done.
            exit 0
        ;;
        -n | --no-alpine)
            alpine=""
            shift 1
        ;;
        -v | --verbose)
            #  It's better to assign a string, than a number like "verbose=1"
            #  because if you're debugging the script with "bash -x" code like this:
            #
            #    if [ "$verbose" ] ...
            #
            #  You will see:
            #
            #    if [ "verbose" ] ...
            #
              #  Instead of cryptic
            #
            #    if [ "1" ] ...
            #
            verbose="verbose"
            shift
        ;;
        --) # End of all options
            shift
            break;
        ;;
         -*)
            echo "Error: Unknown option: $1" >&2
            display_help
            exit 1
        ;;
        *)  # No more options
            display_help
            exit 1
        ;;
    esac
done

