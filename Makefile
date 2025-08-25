
# This is the name of an index server for twine uploads in ~/.pypirc
pypi=pypi

# ------------------------------------------------------------------------------
HIDDEN_PYTHON=$(shell \
	find . -type f -perm -u=x ! -name '*.py' ! -name '*.sh' ! -path './venv/*' \
			! -path './.??*/*' ! -path './doc/*' ! -path './untracked/*' \
			! -path './dist/*' ! -path './*egg-info*' \
		-print0 | xargs -r -0 file | grep 'Python script' | cut -d: -f1)


.PHONY: black help _venv_is_off _venv_is_on _venv update check doc spell test coverage

PKG=ollex
VERSION=$(shell cat $(PKG)/VERSION)

# ------------------------------------------------------------------------------
help:
	@echo
	@echo "What do you want to make?  Available targets are:"
	@echo
	@echo "[31mGetting started[0m"
	@echo "   init:      Initialise / update the project (create venv etc.). Idempotent."
	@echo "   help:      Print this help text."
	@echo
	@echo "[31mBuild / install targets[0m"
	@echo "   all:       Combines pkg and doc"
	@echo "   pkg:       Build the Python package."
	@echo "   pypi:      Upload the pkg to a PyPI server via twine."
	@echo
	@echo "[31mMiscellaneous targets[0m"
	@echo "   black      Format the code using black."
	@echo "   check:     Run some code checks (flake8 etc)."
	@echo "   clean:     Remove generated components, fluff etc."


# ------------------------------------------------------------------------------
# Check virtual environment is not active
_venv_is_off:
	@if [ "$$VIRTUAL_ENV" != "" ] ; \
	then \
		echo Deactivate your virtualenv for this operation ; \
		exit 1 ; \
	fi

_venv_is_on:
	@if [ "$$VIRTUAL_ENV" == "" ] ; \
	then \
		echo Activate your virtualenv for this operation ; \
		exit 1 ; \
	fi
	

# Setup the virtual environment
_venv:	_venv_is_off
	@if [ ! -d venv ] ; \
	then \
		echo Creating virtualenv ; \
		python3 -m venv venv ; \
	fi
	@( \
		echo Activating venv ; \
		source venv/bin/activate ; \
		export PIP_INDEX_URL=$(PIP_INDEX_URL) ; \
		if [ "$(os)" = "amzn2018" -a "$$PYTHON_INSTALL_LAYOUT" = "amzn" ] ; \
		then \
			echo "Aargh - Amazon Linux 1 - pip is broken - unsetting PYTHON_INSTALL_LAYOUT" ; \
			export PYTHON_INSTALL_LAYOUT= ; \
		fi ; \
		echo Installing requirements ; \
		python3 -m pip install 'pip>=20.3' --upgrade ; \
		python3 -m pip install -r requirements.txt --upgrade ; \
		python3 -m pip install -r requirements-build.txt --upgrade ; \
		: ; \
	)

# Check ollama is installed
_ollama:
	@( \
		ollama > /dev/null 2>&1 ; \
		[ $$? -eq 127 ] && echo You need to install ollama from https://ollama.com && exit 1 ; \
		exit 0 ; \
	)

_git:	.git
	git config core.hooksPath etc/git-hooks

# ------------------------------------------------------------------------------
init: 	_venv _git _ollama

black:  _venv_is_on
	black .
	black $(HIDDEN_PYTHON)

check:	_venv_is_on
	etc/git-hooks/pre-commit


all:	pkg doc

pkg:	_venv_is_on
	@mkdir -p dist
	python3 setup.py sdist --dist-dir dist

~/.pypirc:
	$(error You need to create $@ with an index-server section for "$(pypi)")

pypi:	~/.pypirc pkg
	twine upload -r "$(pypi)" "dist/$(PKG)-$(VERSION).tar.gz"

clean:
	$(RM) -r dist
