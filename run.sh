#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/run.sh)
function long_line {
  echo "-----------------------------------------------------------------------------------------------"
}

long_line
echo 
docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'|grep -v ':'
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
rm -rf /var/log/syslog /var/log/syslog.1 /var/log/syslog.2

long_line
echo "remove nillion"
docker stop $(docker ps -aq --filter ancestor=nillion/verifier:v1.0.1) # 2>/dev/null
docker rm $(docker ps -aq --filter ancestor=nillion/verifier:v1.0.1) # 2>/dev/null
docker rmi $(docker images -q nillion/verifier:v1.0.1) # 2>/dev/null
docker volume rm $(docker volume ls -q --filter name=nillion)
rm -rf /root/nillion/  /root/nillion_backups/
long_line

long_line
echo "remove nubit"
docker rmi $(docker images -q nubit_image)
rm -rf /root/nubit*
long_line

# remove dusk
long_line
echo "_____remove dusk______"
docker stop $(docker ps -aq --filter ancestor=rusk-dusk)
docker rm $(docker ps -aq --filter ancestor=rusk-dusk)
docker rmi $(docker images -q rusk-dusk)
long_line

cd ;rm -rf openledger-node* minimadocker* ritual_GB_restart* worker1* worker2* worker3* allora-chain* 0g-chain fake_disk.img log_output.txt penumbra* dawn-installer.tar.gz  dawn_validator_project penymbra* setup_linux.sh availscript.sh config_rivalz.sh elixir screenlog.0 responses.txt  restart_with_remove_container.sh script.log Dockerfile token_stats.txt update.txt



