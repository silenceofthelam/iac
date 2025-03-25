#!/bin/bash

ANSIBLE_INVENTORY=hosts.example.yml
BASE_DIR=$(mktemp -d)
CUSTOM_ENV=1
PWD_ORIG=$(pwd)
PYTHON_BIN=$(which python3)
PYTHON_VERSION=$(basename "$PYTHON_BIN")

echo cd "$BASE_DIR"

cd "$BASE_DIR" || exit

git clone https://github.com/silenceofthelam/iac && cd iac || exit

if [ -n "$1" ]; then
	git checkout "$1"
fi

if [ -z "$VIRTUAL_ENV" ]; then
	CUSTOM_ENV=0
	sudo apt-get install -y "$PYTHON_VERSION"-venv
	echo Using System Python at "$PYTHON_BIN"
	"$PYTHON_BIN" -m venv .venv
	# shellcheck source=/dev/null
	. .venv/bin/activate
	PYTHON_BIN=$(which python3)
fi

pip install -r requirements.txt

if [ -d "$HOME/.ansible/inventory" ]; then
	ANSIBLE_INVENTORY="$HOME/.ansible/inventory"
fi

ansible-playbook ansible/site.yml -i "$ANSIBLE_INVENTORY" --ask-become-pass

if [ "$CUSTOM_ENV" == "0" ]; then
	deactivate
fi

cd "$PWD_ORIG" || exit
rm -rf "$BASE_DIR"
