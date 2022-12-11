#/bin/bash

# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/bootstrap-fix.sh)

function colors {
  GREEN="\e[32m"
  RED="\e[39m"
  NORMAL="\e[0m"
}

function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}


function replace_bootstraps {
	config_path="$HOME/massa/massa-node/base_config/config.toml"
	bootstrap_list=`wget -qO- https://raw.githubusercontent.com/RomanTsibii/nodes/main/massa/bootstrap_list.txt | shuf -n50 | awk '{ print "        "$0"," }'`
	len=`wc -l < "$config_path"`
	start=`grep -n bootstrap_list "$config_path" | cut -d: -f1`
	end=`grep -n "\[optionnal\] port on which to listen" "$config_path" | cut -d: -f1`
	end=$((end-1))
	first_part=`sed "${start},${len}d" "$config_path"`
	second_part="
    bootstrap_list = [
${bootstrap_list}
    ]
"
	third_part=`sed "1,${end}d" "$config_path"`
	echo "${first_part}${second_part}${third_part}" > "$config_path"
	sed -i -e "s%retry_delay *=.*%retry_delay = 15000%; " "$config_path"
	grep bootstrap_whitelist_file $config_path || sed -i "/\[bootstrap\]/a  bootstrap_whitelist_file = \"base_config/bootstrap_whitelist.json\"" "$config_path"
	grep bootstrap_blacklist_file $config_path || sed -i "/\[bootstrap\]/a  bootstrap_blacklist_file = \"base_config/bootstrap_blacklist.json\"" "$config_path"
  sudo systemctl restart massa
}


line
replace_bootstraps
line
echo -e "${GREEN}DONE${NORMAL}"
