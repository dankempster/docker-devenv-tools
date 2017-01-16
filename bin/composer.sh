#!/usr/bin/env bash

docker run --rm -u 82:82 -v $(pwd):/project -v composer_alpine:/composer -v composer_cache_alpine:/composer-cache -w /project dankempster/composer:alpine --ansi $*
