#!/bin/bash

/root/gaianet/bin/gaianet run >> /var/log/gaianet.log 2>&1
/root/gaianet/bot_gaia.sh >> /var/log/bot_gaia.log 2>&1 &
