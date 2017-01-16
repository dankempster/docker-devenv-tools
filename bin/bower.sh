#!/usr/bin/env bash

docker run --rm -u www-data:www-data -v $(pwd):/project -v bower:/bower -w /project dankempster/bower:latest $*
