#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/cp_minidat_to_dockers.sh)

FOLDERS='minimadocker48201
minimadocker48211
minimadocker48221
minimadocker48231
minimadocker48241
minimadocker48251
minimadocker48261
minimadocker48271
minimadocker48281
minimadocker48403
minimadocker48413
minimadocker48423
minimadocker48433
minimadocker48443
minimadocker48453
minimadocker48463
minimadocker48473
minimadocker48483
minimadocker48605
minimadocker48615
minimadocker48625
minimadocker48635
minimadocker48645
minimadocker48655
minimadocker48665
minimadocker48675
minimadocker48685
minimadocker48807
minimadocker48817
minimadocker48827
minimadocker48837
minimadocker48847
minimadocker48857
minimadocker48867
minimadocker48877
minimadocker48887
minimadocker48909
minimadocker48919
minimadocker48929
minimadocker48939
minimadocker48949
minimadocker48959
minimadocker48969
minimadocker48979'

cd $HOME
wget https://github.com/RomanTsibii/nodes/raw/main/minima/iprewards-2.15.1.mds.zip
  for DOCKER_FOLDER in ${FOLDERS}
  do
    if [[ -n $DOCKER_FOLDER ]]; then
      cp iprewards-2.15.1.mds.zip $DOCKER_FOLDER
    fi
  done
apt install tree -y 
tree minimadocker48*
