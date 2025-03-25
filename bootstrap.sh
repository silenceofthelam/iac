#!/bin/bash

PWD_ORIG=$(pwd)
BASE_DIR=$(mktemp -d)

echo cd "$BASE_DIR"

cd "$BASE_DIR" || exit

git clone https://github.com/silenceofthelam/iac && cd iac || exit

if [ -n "$1" ]; then
	git checkout "$1"
fi

PYTHON_BIN=$(which python3)
PYTHON_VERSION=$(basename "$PYTHON_BIN")

echo Using Python at "$PYTHON"

sudo apt-get install -y "$PYTHON_VERSION"-venv

"$PYTHON_BIN" -m venv .venv

# shellcheck source=/dev/null
. .venv/bin/activate

pip install -r requirements.txt

ansible-playbook ansible/site.yml

cd "$PWD_ORIG" || exit
rm -rf "$BASE_DIR"
