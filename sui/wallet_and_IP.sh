#!/bin/bash

source $HOME/.profile

echo "http://`wget -qO- eth0.me`:9000/"
sui keytool list
