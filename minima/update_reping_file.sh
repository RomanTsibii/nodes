#!/bin/bash
# bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/update_reping_file.sh)

cat << EOF > /root/minima_reping_base.sh
#!/bin/bash
bash <(curl -s  https://raw.githubusercontent.com/RomanTsibii/nodes/main/minima/reping_all_port5.sh)
EOF