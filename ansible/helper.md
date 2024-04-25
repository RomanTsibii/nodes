



nano /etc/ansible/ansible.cfg
ansible new_contabo -m ping

# Shell

ansible tsibaa_contabo -m shell -a "df -h | grep sda3"

ansible new_contabo -m file -a "path=/home/privet.txt state=abcent" -b

ansible new_contabo -m get_url -a "url=шлях до файлу загрузки dest=/home" -b # префікс -b це запуск з sudo правами

ansible new_contabo -m yum -a "name=screen state=installed use_backend=yum4" -b # установка апок (не працювал)

ansible new_contabo -m uri -a "url=http://google.com"  #  перевірити чи є доступ до сайту

ansible new_contabo -m uri -a "url=http://google.com return_content=yes"  #  перевірити чи є доступ до сайту і вивести код сайту


### дебагінг -v -vv -vvv -vvvvv

ansible new_contabo -m shell -a "ls /" -v

ansible-doc -l 
