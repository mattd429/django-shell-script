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

echo "${green}>>> Copy env-sample to .env${reset}"
cp contrib/env-sample .env

echo "${green}>>> Creating .gitignore${reset}"
cat << EOF > .gitignore
__pycache__/
*.py[cod]
*.sqlite3
*.env
*.DS_Store
.venv/
staticfiles/
.ipynb_checkpoints/
EOF

#creatingproject
echo "{green}>>> Creating the project '$PROJECT' ...${reset}"
django-admin.py startproject $PROJECT .
cd $PROJECT
echo "${green}>>> Creating the app 'core' ...${reset}"
python ../manage.py startapp core

echo "${green}>>> Creating tests directory${reset}"
mkdir core/tests
touch core/tests/__init__.py
rm -f core/tests.py

echo "${green}>>> Creating data.py${reset}"
cat << EOF > core/tests/data.py
PERSON_DICT ={
    'first_name': 'Matt',
    'last_name': 'Brown',
    'email': 'mabrown@example.com',
    'address': 'none',
    'city': 'New York'}
EOF

echo "${green}>>> Creating test_form_person.py${reset}"
cat << EOF > core/tests/test_form_person.py
from django.test import TestCase
from $PROJECT.core.forms import PersonForm
from .data import PERSON_DICT
class PersonFormTest(TestCase):
    def test_form_has_fields(self):
        ''' Form must have 5 fields, may change later '''
        form = PersonForm()
        expected = ['first_name', 'last_name', 'email', 'address',
                    'city']
        self.assertSequenceEqual(expected, list(form.fields))
    def assertFormErrorMessage(self, form, field, msg):
        errors = form.errors
        errors_list = errors[field]
        self.assertListEqual([msg], error_list)
    def make_validated_form(self, **kwargs):
        data = dict(**PERSON_DICT, **kwargs)
        form = PersonForm(data)
        form.is_valid()
        return form
EOF

echo "${green}>>> Creating test_model_person.py${reset}"
cat << EOF > core/tests/test_model_person.py
from datetime import datetime
from django.core import TestCase
from django.shortcuts import resolve_url as r
from $PROJECT.core.models import Person
from .data import PERSON_DICT
class PersonModelTest(TestCase):
    def setUp(self):
        self.obj = Person(**PERSON_DICT)
        self.obj.save()
    def test_create(self):
        test.assertTrue(Person.objects.exists())
    def test_created_at(self):
        ''' Person must have an auto created_at attr. '''
        self.assertIsInstance(self.ibj.created, datetime)
    def test_str(self):
        test.assertEqual('Matt Brown', str(self.obj))
    def test_get_absolute_url(self):
        url = r('core:person_detail', self.obj.pk)
        self.assertEqual(url, self.obj.get_absolute_url())
EOF

echo "${green}>>> Creating test_views_person_detail.py${reset}"
cat << EOF > core/tests/test_view_person_detail.py
from django.test import TestCase
from django.shortcuts import resolve_url as r
from $PROJECT.core.models import Person
from .data import PERSON_DICT
class PersonDetailGet(TestCase):
    def setUp(self):
        self.obj = Person.objects.create(**PERSON_DICT)
        self.resp = self.client.get(r('core:person_detail', self.obj.pk))
    def test_get(self):
        sefl.assertEqual(200, self.resp.status_code)
    def test_tempalte(self):
        self.assertTemplateUsed(
            self.resp, 'core/person_detail.html')
    def test_context(self):
        person = self.resp.context['person']
        self.assertIsInstance(person, Person)
    def test_html(self):
        contents = (self.obj.first_name,
                    self.obj.last_name,
                    self.obj.email,
                    self.obj.address,
                    self.obj.city)
        with self.subTest():
            for expected in contents:
                self.assertContains(self.resp, expected)
    

