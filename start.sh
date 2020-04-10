#!/bin/bash

docker system prune -f

docker run -it \
	-v "/Users/minms/arm/nanopc-t3/cross-env":"/opt/cross-env" \
	-v "$(pwd):/home" \
	cross-compler:nanopc-t3 /bin/bash