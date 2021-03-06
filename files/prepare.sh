#!/bin/sh

set -x

SERVICES=${@:-$(/bin/find /containers/ -type d -maxdepth 2 -mindepth 2)}

for DIR in $SERVICES; do
        NAME=${DIR##*/}
        TYPE=$(echo $DIR | /bin/cut -d / -f 3)

        /bin/sed "s#{{NAME}}#$NAME#g" /etc/unitfile.tpl | \
        /bin/sed "s#{{DIR}}#$DIR#g" | \
        /bin/sed "s#{{TYPE}}#$TYPE#g" > /etc/unitfiles/$NAME.service

        /bin/mount -t overlay overlay -o lowerdir=$DIR/lower,upperdir=$DIR/rootfs,workdir=$DIR/tmp $DIR/rootfs
done
