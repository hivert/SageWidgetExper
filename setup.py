## -*- encoding: utf-8 -*-
import os
import sys
from setuptools import setup
from codecs import open # To open the README file with proper encoding
from setuptools.command.test import test as TestCommand # for tests


# Get information from separate files (README, VERSION)
def readfile(filename):
    with open(filename,  encoding='utf-8') as f:
        return f.read()

# For the tests
class SageTest(TestCommand):
    def run_tests(self):
        errno = os.system("sage -t --force-lib jeudetaquin")
        if errno != 0:
            sys.exit(1)

setup(
    name = "SageWidgetExper",
    version = readfile("VERSION"),
    description='Experiments with Sage Widgets',
    long_description = readfile("README.md"),
    url='https://github.com/hivert/SageWidgetExper',
    author='Florent Hivert',
    author_email='florent.hivert@u-psud.fr',
    license='GPLv2+',
    classifiers=[
      # How mature is this project? Common values are
      #   3 - Alpha
      #   4 - Beta
      #   5 - Production/Stable
      'Development Status :: 3 - Alpha',
      'Intended Audience :: Science/Research',
      'Topic :: Scientific/Engineering :: Mathematics',
      'License :: OSI Approved :: GNU General Public License v2 or later (GPLv2+)',
      'Programming Language :: Python :: 2.7',
    ], # classifiers list: https://pypi.python.org/pypi?%3Aaction=list_classifiers
    keywords = "",
    packages = ['jeudetaquin'],
    cmdclass = {'test': SageTest}, # adding a special setup command for tests
    install_requires = ['sage-combinat-widgets']
)
