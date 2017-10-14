#!/usr/bin/env bash

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

composer () {
    docker-compose -f ddet/docker-compose.composer.yml up -d

    return 0
}

bower () {
    docker-compose -f ddet/docker-compose.bower.yml up -d

    return 0
}

adminer () {
    docker-compose -f ddet/docker-compose.adminer.yml up -d

    return 0
}

docker_compose_ps () {
    echo "###"
    echo "# Reverse Proxy"
    echo "#"
    docker-compose \
        -f reverse-proxy/docker-compose.yml \
        ps

    echo ""
    echo "###"
    echo "# DDET Services"
    echo "#"
    docker-compose \
        -f ddet/docker-compose.adminer.yml \
        -f ddet/docker-compose.composer.yml \
        -f ddet/docker-compose.bower.yml \
        ps
}

reverse_proxy () {
    docker-compose \
        -f reverse-proxy/docker-compose.yml \
        up -d

    return 0
}

while :
do
    case "$1" in
        adminer)
            # set up reverse proxy
            reverse_proxy

            # start adminer
            adminer
            exit 0
        ;;
        all)
            # initialise volumes
            bower
            composer

            # set up reverse proxy
            reverse_proxy

            # start web services
            adminer

            # show result
            docker_compose_ps
            exit 0
        ;;
        init)
            bower
            composer
            exit 0
        ;;
        proxy)
            reverse_proxy
            exit 0
        ;;
#        ps)
#            docker_compose_ps
#            exit 0
#        ;;
        ps|status)
            docker_compose_ps
            exit 0
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

