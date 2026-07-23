#!/usr/bin/env bash

cd /opt/l-panel/backend

source venv/bin/activate


python -c "
from wsgi import app
print('Backend import OK')
"
