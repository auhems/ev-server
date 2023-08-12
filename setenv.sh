#!/bin/bash

# echo '${BASH_SOURCE[@]}='${BASH_SOURCE[@]}
# echo '${#BASH_SOURCE[@]}='${#BASH_SOURCE[@]}
# echo '${BASH_SOURCE}='${BASH_SOURCE}
# echo '${0}='${0}

if [ ${#BASH_SOURCE[@]} -eq 1 ] && [ ${BASH_SOURCE[0]} = ${0} ]; then
  echo "Stop! Please try \`source ${0}\` instead."
  exit 1
fi

PROJECT_ROOT=$(cd `dirname $BASH_SOURCE[0]` && pwd)
export PROJECT_ROOT

if [ -f requirements.txt ]; then
  # this is likely to be a python project
  if [ ! -d venv ]; then
    python3 -m venv venv
    touch venv/pip.conf
    . venv/bin/activate
    pip install -r requirements.txt
  else
    if [ "`which python`" != "PROJECT_ROOT/venv/bin/python" ]; then
      . venv/bin/activate
    fi
  fi
fi

export VARIABLE_A='value'

LOCAL_ENV=${PROJECT_ROOT}/.env

if [ -e ${LOCAL_ENV} -a -f ${LOCAL_ENV} ]; then
  source ${LOCAL_ENV}
fi
