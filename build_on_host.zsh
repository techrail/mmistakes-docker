#!/usr/bin/env zsh

if [[ ! -v MM_SOURCE ]]; then
	echo "MM_SOURCE is not set"
	return 1
else
	echo "MM_SOURCE = $MM_SOURCE"
fi

if [[ ! -v MM_DESTINATION ]]; then
	echo "MM_DESTINATION is not set"
	return 2
else
	echo "MM_DESTINATION = $MM_DESTINATION"
fi

uid=$(id -u)
if [[ $? -ne 0 ]]; then
	echo "Running command 'id -u' failed. CANNOT PROCEED."
	return 3
else
	echo "UID = $uid"
fi

gid=$(id -g)
if [[ $? -ne 0 ]]; then
	echo "Running command 'id -g' failed. CANNOT PROCEED."
	return 4
else
	echo "GID = $gid"
fi

docker run -t -i \
  --mount "type=bind,target=/source,source=$MM_SOURCE"\
  --mount "type=bind,target=/destination,source=$MM_DESTINATION"\
  mmistakes:latest\
  /app/build_site.zsh $uid $gid


