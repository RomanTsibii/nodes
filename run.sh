#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/run.sh)
function long_line {
  echo "-----------------------------------------------------------------------------------------------"
}

long_line
echo "REMOVE IMAGES WITHOUT TEGS"
docker images -q -a | xargs docker inspect --format='{{.Id}}{{range $rt := .RepoTags}} {{$rt}} {{end}}'|grep -v ':' 2>/dev/null
docker rmi $(docker images --filter "dangling=true" -q --no-trunc) 2>/dev/null
rm -rf /var/log/syslog /var/log/syslog.1 /var/log/syslog.2 2>/dev/null

long_line
echo "remove nillion"
docker stop $(docker ps -aq --filter ancestor=nillion/verifier:v1.0.1)  2>/dev/null
docker rm $(docker ps -aq --filter ancestor=nillion/verifier:v1.0.1)  2>/dev/null
docker rmi $(docker images -q nillion/verifier:v1.0.1)  2>/dev/null
docker volume rm $(docker volume ls -q --filter name=nillion) 2>/dev/null
rm -rf /root/nillion/  /root/nillion_backups/ 2>/dev/null
long_line

long_line
echo "remove nubit"
docker rmi $(docker images -q nubit_image) 2>/dev/null
rm -rf /root/nubit* 2>/dev/null
long_line

# remove dusk
long_line
echo "_____remove dusk______"
docker stop $(docker ps -aq --filter ancestor=rusk-dusk) 2>/dev/null
docker rm $(docker ps -aq --filter ancestor=rusk-dusk) 2>/dev/null
docker rmi $(docker images -q rusk-dusk) 2>/dev/null
long_line

cd ;
rm -rf openledger-node* minimadocker* ritual_GB_restart* worker1* worker2* worker3* allora-chain* 0g-chain fake_disk.img log_output.txt penumbra* dawn-installer.tar.gz  dawn_validator_project  2>/dev/null
rm -rf penymbra* setup_linux.sh availscript.sh config_rivalz.sh elixir screenlog.0 responses.txt  restart_with_remove_container.sh script.log Dockerfile token_stats.txt update.txt 2>/dev/null
rm -rf vmagent-prod vmalert-prod vmbackup-prod vmctl-prod vmrestore-prod vmauth-prod 0.9.3.tar.gz* /root/.0gchain allora-huggingface-walkthrough /root/.allorad 2>/dev/null
rm -rf .rivalz .sonaric elixir 2>/dev/null

sudo systemctl stop rivalz 2>/dev/null
sudo systemctl disable rivalz 2>/dev/null
sudo systemctl daemon-reload 2>/dev/null

docker rm -f elixir 2>/dev/null

docker stop opl_worker opl_scraper allora-worker-1 allora-worker-3 allora-worker-2 allora-updater-1 allora-updater-2 allora-updater-3 allora-inference-1 allora-inference-2 allora-inference-3 2>/dev/null
docker rm opl_worker opl_scraper allora-worker-1 allora-worker-3 allora-worker-2 allora-updater-1 allora-updater-2 allora-updater-3 allora-inference-1 allora-inference-2 allora-inference-3 2>/dev/null

# видалити всі контейнери з алорою 
docker ps -a | grep allora | awk '{print $1}' | xargs docker rm -f 2>/dev/null
# видалити всі images з алорою 
docker images | grep worker | awk '{print $3}' | xargs docker rmi -f 2>/dev/null 
# видалити всі network з алорою 
docker network rm worker1-10m_default worker2-24h_default worker3-20m_default 2>/dev/null
# видалити всі volume з алорою 
# docker volume prune -f
# видалити імеджі якщо там є allora
docker images | grep allora | awk '{print $3}' | xargs docker rmi -f 2>/dev/null
docker images | grep chasm | awk '{print $3}' | xargs docker rmi -f 2>/dev/null
docker images | grep bevm | awk '{print $3}' | xargs docker rmi -f 2>/dev/null
docker images | grep elixir | awk '{print $3}' | xargs docker rmi -f 2>/dev/null
docker images | grep minima | awk '{print $3}' | xargs docker rmi -f 2>/dev/null
docker images | grep basic-coin | awk '{print $3}' | xargs docker rmi -f 2>/dev/null
docker images | grep openledgerhub | awk '{print $3}' | xargs docker rmi -f 2>/dev/null
# docker images | grep waku | awk '{print $3}' | xargs docker rmi -f

sudo systemctl stop cysic.service
sudo systemctl disable cysic.service

