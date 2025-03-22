#!/bin/bash

BASE_DIR=$(mktemp -d)

echo cd $BASE_DIR

cd $BASE_DIR

git clone https://github.com/silenceofthelam/iac

PYTHON_BIN=$(which python3)
PYTHON_VERSION=$(basename $PYTHON_BIN)

echo Using Python at $PYTHON

sudo apt-get install -y $PYTHON_VERSION-venv

$PYTHON_BIN -m venv .venv

. .venv/bin/activate

pip install ansible

cd - 
rm -rf $BASE_DIR


