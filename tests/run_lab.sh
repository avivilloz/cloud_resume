#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Provide <project_base_dir> and <lab_name> as argument."
    exit 1
fi

project_base_dir=$1
lab_name=$2
pytest_args=""
venv_name="venv"
lab_dir="$project_base_dir/tests/$lab_name"

if [ $lab_name == "frontend" ]; then
    pytest_args="--website-url=https://dev.avivilloz.com"
elif [ $lab_name == "backend" ]; then
    pytest_args="--api-url=https://dev-api.avivilloz.com"
fi

python -m venv $venv_name
. $venv_name/bin/activate
pip install -r $lab_dir/requirements.txt
pytest -s $lab_dir $pytest_args
