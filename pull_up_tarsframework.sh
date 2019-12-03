#!/bin/sh
cd /usr/local/app/tars

#拉起tarsregistry
tarsregistry/util/start.sh

#拉起tarsAdminRegistry
tarsAdminRegistry/util/start.sh

#拉起tarsconfig
tarsconfig/util/start.sh

#拉起tarsnode
tarsnode/util/start.sh

#拉起web
cd /usr/local/tarscode/Tars/web/config
npm run prd
pm2 start 0
