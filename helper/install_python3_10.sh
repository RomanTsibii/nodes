#!/bin/bash
# set -e

check_python_version() {
  if command -v python3 &>/dev/null; then
    PY_VERSION=$(python3 -V 2>&1 | awk '{print $2}')
    if [[ "$PY_VERSION" == 3.10.* ]]; then
      echo "[✔] Python 3.10 вже встановлено: $PY_VERSION"
      # exit 0
    else
      echo "[!] Поточна версія Python: $PY_VERSION — не 3.10"
    fi
  else
    echo "[!] Python3 не знайдено"
  fi
}

install_python_3_10_from_source() {
  echo "[🔧] Встановлюємо Python 3.10.14 з вихідного коду..."

  sudo apt update
  sudo apt install -y \
    wget build-essential libssl-dev zlib1g-dev libncurses5-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev \
    libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev uuid-dev

  cd /usr/src
  sudo wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz
  sudo tar xzf Python-3.10.14.tgz
  cd Python-3.10.14

  sudo ./configure --enable-optimizations
  sudo make -j$(nproc)
  sudo make altinstall

  sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.10 1
  sudo update-alternatives --set python3 /usr/local/bin/python3.10

  echo "[+] Встановлено Python 3.10:"
  python3 --version

  echo "[+] Встановлюємо pip для Python 3.10..."
  curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3
  pip3 --version

  echo "[✅] Python 3.10 успішно встановлено"
}

check_python_version
install_python_3_10_from_source
