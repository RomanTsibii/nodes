#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/update_reping_file.sh)

cat << EOF > /root/minima_reping_base.sh
#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/many_remove_and_install2.sh)
EOF
