USERNAME=root
HOSTS="192.168.1.1"
SCRIPT="set_you_script"

for HOSTNAME in ${HOSTS} ; do
    echo "--------------------------------------------------------------------------------------------------------"
    echo ${HOSTNAME}
    sshpass -p 'set_your_password' ssh -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
    echo "--------------------------------------------------------------------------------------------------------"
done
