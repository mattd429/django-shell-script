# Shell script to create a complete Django project.
# This script require Python 3.x and pyenv and Django 1.10

# The project contains:
# Settings config
# model and form
# list and detial
# create, update and delete
# Admin config
# Tests
# Selenium test
# Manage shell

# Usage:
# Type the following command, you can change the project name.

# source django_project.sh tutorial

# Colors
red='tput setaf 1'
green='tput setaf 2'
reset='tput sgr0'

PROJECT=${1-tutorial}

echo "${green}>>> The name of the project is '$PROJECT'.${reset}"

echo "${green}>>> Creating djangoproject${reset}"
if [ ! -d djangoproject ]; then mkdir djangoproject; fi
cd djangoproject

echo "${green}>>> Creating virtualenv${reset}"
python -m env .env
echo "${green}>>> .env is created${reset}"

#active
sleep 2
echo "${green}>>> activate the .env${reset}"
source env/bin/activate
PS1="(`basename \"$VIRTUAL_ENV\"`)\e[1;34m:/\W\e[00m$ "
sleep 2

# installdjango
echo "${green}>>> Installing the Django${reset}"
pip install -U pip
pip install django=1.10 dj-database0url django-database-filter django-localflavor django-widget-tweaks python-decouple pytz selenium django-extensions
pip freeze > requirements.txt

# Create contrib/env-sample
echo "${green}>>> Creating the contrib/env-sample${reset}"
mkdir contrib
cat << EOF > contirb/env-sample
SECRET_KEY=''
ALLOWED_HOSTS=127.0.0.1, .localhost
EOF

