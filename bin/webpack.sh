#!/usr/bin/env bash

docker run --rm -u www-data:www-data -v $(pwd):/project -w /project dankempster/webpack:latest webpack $*
