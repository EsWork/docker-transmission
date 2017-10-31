#!/bin/bash
set -e

[[ -d $TRANSMISSION_DIR/downloads ]] || mkdir -p $TRANSMISSION_DIR/downloads
[[ -d $TRANSMISSION_DIR/incomplete ]] || mkdir -p $TRANSMISSION_DIR/incomplete
[[ -d $TRANSMISSION_DIR/info/blocklists ]] || mkdir -p $TRANSMISSION_DIR/info/blocklists

if [ ! -f $TRANSMISSION_DIR/info/settings.json ];then
   echo "copy default settings file"
   cp /etc/transmission/settings.json $TRANSMISSION_DIR/info/settings.json
   chmod 600 $TRANSMISSION_DIR/info/settings.json
fi

chown -R transmission:transmission $TRANSMISSION_DIR

if [[ $# -ge 1 && -x $(which $1 2>&-) ]]; then
    exec "$@"
elif [[ $# -ge 1 ]]; then
    echo "ERROR: command not found: $1"
    exit 13
elif ps -ef | egrep -v 'grep|transmission.sh' | grep -q transmission; then
    echo "Service already running, please restart container to apply changes"
else
    if [[ -z $(find $TRANSMISSION_DIR/info/blocklists/bt_level1 -mmin -1080 2>&-) && \
                "${BLOCKLIST:-""}" != "no" ]]; then
        # Initialize blocklist
        url='http://list.iblocklist.com'
        curl -Ls "$url"'/?list=bt_level1&fileformat=p2p&archiveformat=gz' |
                    gzip -cd >$TRANSMISSION_DIR/info/blocklists/bt_level1
        chown transmission. $TRANSMISSION_DIR/info/blocklists/bt_level1
    fi
   exec su-exec transmission:transmission /bin/bash -c "exec transmission-daemon \
                --allowed \\* --blocklist --config-dir $TRANSMISSION_DIR/info \
                --foreground --log-info --no-portmap \
                $([[ ${NOAUTH:-""} ]] && echo '--no-auth' || echo "--auth \
                --username ${TRUSER:-admin} --password ${TRPASSWD:-admin}")"
fi
