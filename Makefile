.PHONY: help prepare-dev test run venv clean-build build clean-pyc
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

VENV=./bin
PYTHON=${VENV}/python
PYINSTALLER=$(VENV)/pyinstaller
WORKDIR=./atbswp

.DEFAULT: help
help: ## Display this help section
> @awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-38s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help


prepare-dev: ## Prepare the development environment
> @python -m venv .
> @$(PYTHON) -m pip install --upgrade pip
> @${PYTHON} -m pip install -r requirements-dev.txt
> @echo
> @echo
> @echo Now you need to copy the wx folder from the site-packages of your distribution to the site-packages of the virtual environnement.
> @echo
> @echo

test: $(VENV)/activate  ## Run all tests
> ${PYTHON} -m pytest

clean-pyc: $(VENV)  ## Clean all the pyc files
> find . -name '*.pyc' -exec rm --force {} +
> find . -name '*.pyo' -exec rm --force {} +
> name '*~' -exec rm --force  {}

clean-build: $(VENV)/activate ## Clean previous build
> @rm --force --recursive build/
> @rm --force --recursive dist/
> @rm --force --recursive *.egg-info
> make build

build: $(VENV)/activate ## Build the project for the current platform
> $(PYINSTALLER) $(WORKDIR)/atbswp.py && \
> cp -r $(WORKDIR)/img dist/atbswp/

run: $(VENV)/activate  ## Launch the project
> $(PYTHON) $(WORKDIR)/atbswp.py

show-venv: $(VENV)/activate  ## Show venv parameters
>	@$(VENV)/python -c "import sys; print('Python ' + sys.version.replace('\n',''))"
> @echo
>	@$(VENV)/pip --version
> @echo

clean-venv:  ##  Remove virtual environment
> @rm --force --recursive bin/
> @rm --force --recursive include/
> @rm --force --recursive lib/
> @rm --force	lib64
> @rm --force pyvenv.cfg