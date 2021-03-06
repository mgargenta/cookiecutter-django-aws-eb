#!/bin/bash

source_root="{{ cookiecutter.source_root }}"

require_program() {
    theprogram="$1"
    $theprogram --version >/dev/null 2>&1 || { echo >&2 "---> $theprogram is required for this cookiecutter"; exit 1; }
}

echo "---> Running pre-hook script..."

aws_eb_type="{{ cookiecutter.aws_eb_type }}"
if [ "$aws_eb_type" != "python" ] && [ "$aws_eb_type" != "docker" ]; then
    echo "---> aws_eb_type can only have the value of 'python' or 'docker'"; exit 1;
fi

require_program "{{ cookiecutter.virtualenv_bin }}"
if [ "{{ cookiecutter.setup_local_env }}" == "yes" ]; then
    require_program "createdb"
fi

{{ cookiecutter.virtualenv_bin }} .ve
.ve/bin/pip install -q "django=={{ cookiecutter.django_version }}"
mkdir "$source_root" && .ve/bin/django-admin.py startproject -v 0 "{{ cookiecutter.project_name }}" "{{ cookiecutter.source_root }}"

echo "---> DONE Running pre-hook script..."
