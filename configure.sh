#!/bin/bash

# Install Development Packages

sudo apt-get install python3-pip

pip install -r requirements-dev.txt

pre-commit install
