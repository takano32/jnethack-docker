#!/bin/sh
set -e

HACKDIR=/usr/local/games/lib/nethackdir
PRISTINE=/usr/local/share/nethackdir

# Seed the playground.  The files below belong to the image and are refreshed
# on every start so that an update is not shadowed by an older volume; the
# save files, bones, scores and sysconf are left alone.
mkdir -p ${HACKDIR}/save
for file in nethack recover nhdat symbols license; do
	cp -p ${PRISTINE}/${file} ${HACKDIR}/${file}
done

test -f ${HACKDIR}/sysconf || cp -p ${PRISTINE}/sysconf ${HACKDIR}/sysconf

for file in perm record logfile xlogfile livelog; do
	if ! test -f ${HACKDIR}/${file}; then
		touch ${HACKDIR}/${file}
		chmod 0600 ${HACKDIR}/${file}
	fi
done

# allow "docker run <image> --version" as well as "docker run <image> sh"
case "$1" in
-*) set -- /usr/local/games/nethack "$@" ;;
esac

exec "$@"
