#!/bin/bash

python_path={{ PYTHON }}
src_path={{ SRC }}
log_path={{ LOG }}

cd $src_path

$python_path manage.py $1 --settings="{{ SETTINGS }}" >> $log_path 2>&1
