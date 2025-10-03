"""setup.py for ollex."""

from __future__ import annotations

from itertools import chain
from pathlib import Path

from setuptools import find_packages, setup

__version__ = (Path(__file__).parent / 'ollex' / 'VERSION').read_text().strip()

REPO_URL = 'https://github.com/jin-gizmo/ollex'
REQUIRES_PYTHON = '>=3.11.0'


# ------------------------------------------------------------------------------
def looks_like_script(path: Path) -> bool:
    """Check if a file looks like a script."""

    if not (path.is_file() and (stat := path.stat()).st_size > 2 and stat.st_mode & 0o100):
        return False

    with open(path) as fp:
        return fp.read(2) == '#!'


# ------------------------------------------------------------------------------
def find_scripts(*dirs: str) -> list[str]:
    """Find all executable scripts in the specified directory."""

    return [str(f) for f in chain(*(Path(d).glob('*') for d in dirs)) if looks_like_script(f)]


# ------------------------------------------------------------------------------
# Import README.md and use it as the long-description. Must be in MANIFEST.in
with open('PYPI.md') as fp:
    long_description = '\n' + fp.read()

# ------------------------------------------------------------------------------
# Get pre-requisites from requirements.txt. Must be in MANIFEST.in
with open('requirements.txt') as fp:
    required = [s.strip() for s in fp.readlines()]

# ------------------------------------------------------------------------------
setup(
    name='ollex',
    version=__version__,
    packages=find_packages(exclude=['tests', '*.tests', '*.tests.*', 'tests.*']),
    url=REPO_URL,
    scripts=find_scripts('bin'),
    license='3-Clause BSD License',
    author='Murray Andrews',
    description='Open LLM Experimental Workbench',
    long_description=long_description,
    long_description_content_type='text/markdown',
    platforms=['macOS', 'Linux'],
    python_requires=REQUIRES_PYTHON,
    install_requires=required,
    include_package_data=True,
    classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: Information Technology',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Operating System :: MacOS',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 3 :: Only',
        'Topic :: Scientific/Engineering :: Artificial Intelligence',
    ],
)
