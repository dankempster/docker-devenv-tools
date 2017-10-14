#!/usr/bin/env bash

#set -x

adminerConfig="-f ddet/docker-compose.adminer.yml"
bowerConfig="-f ddet/docker-compose.bower.yml"
composerConfig="-f ddet/docker-compose.composer.yml"
reverseProxyConfig="-f reverse-proxy/docker-compose.yml"

display_help ()
{
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

adminer_loadConfig ()
{
    if [ -e adminer.override.yml ]; then
        adminerConfig="${adminerConfig} -f adminer.override.yml"
    else
        adminerConfig="${adminerConfig} -f ddet/docker-compose.adminer-proxy.yml"
    fi

    return 0
}

adminer ()
{
    docker-compose ${adminerConfig} up -d

    return 0
}

bower_loadConfig ()
{
    if [ -e bower.override.yml ]; then
        bowerConfig="${bowerConfig} -f bower.override.yml"
    fi

    return 0
}

bower ()
{
    bower_loadConfig

    docker-compose ${bowerConfig} up -d

    return 0
}

composer_loadConfig ()
{
    if [ -e composer.override.yml ]; then
        composerConfig="${composerConfig} -f composer.override.yml"
    fi
}

composer ()
{
    composer_loadConfig
    
    docker-compose ${composerConfig} up -d

    return 0
}

docker_compose_ps ()
{
    echo "###"
    echo "# Reverse Proxy"
    echo "#"

    adminer_loadConfig
    bower_loadConfig
    composer_loadConfig
    reverseProxy_loadConfig

    docker-compose \
        ${reverseProxyConfig} \
        ps

    echo ""
    echo "###"
    echo "# DDET Services"
    echo "#"
    docker-compose \
        ${adminerConfig} \
        ${composerConfig} \
        ${bowerConfig} \
        ps
}

reverseProxy_loadConfig ()
{
    if [ -e adminer.override.yml ]; then
        reverseProxyConfig="${reverseProxyConfig} -f adminer.override.yml"
    fi
}

reverseProxy ()
{
    reverseProxy_loadConfig

    docker-compose \
        ${reverseProxyConfig} \
        up -d

    return 0
}

while :
do
    case "$1" in
        adminer)
            # set up reverse proxy
            reverseProxy

            # start adminer
            adminer
            exit 0
        ;;
        all)
            # initialise volumes
            bower
            composer

            # set up reverse proxy
            reverseProxy

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
            reverseProxy
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

