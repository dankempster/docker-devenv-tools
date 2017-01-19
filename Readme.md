# Docker Development Environment Tools

This project solves two situations for me:

 1. Quick installation and set up of development tools that can be easily shared; And
 2. Share the tool's caches between separate projects.


## Provided Tools

 - [Composer](https://getcomposer.org)
 - [Bower](https://bower.io)
 - [WebPack](https://webpack.js.org)
 
For each global container an executable script is provided in [bin/](bin/).
These scripts execute simple ```docker run``` commands to invoke the containers, mounting your current path within the container, before running your command.

## Share Tool Caches

Several of the tools provided by this project maintain their own cache to speed up future use of the tool.

For example, Composer maintains a cache of all packages it has download, so should
a second project need some of the same packages, they can simply be loaded from cache speeding up installation/upgrading of dependencies.

TODO: FINISH README ! ! ! 