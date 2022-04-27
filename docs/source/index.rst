.. Octache documentation master file

.. image:: https://github.com/Remi-Gau/Octache/actions/workflows/miss_hit_code_style.yml/badge.svg?branch=main
   :target: https://github.com/Remi-Gau/Octache/actions/workflows/miss_hit_code_style.yml
   :alt: MISS_HIT: code style

.. image:: https://github.com/Remi-Gau/Octache/actions/workflows/miss_hit_code_quality.yml/badge.svg?branch=main
   :target: https://github.com/Remi-Gau/Octache/actions/workflows/miss_hit_code_quality.yml
   :alt: MISS_HIT: code quality

.. image:: https://github.com/Remi-Gau/Octache/actions/workflows/octave_test_and_coverage.yml/badge.svg?branch=main
   :target: https://github.com/Remi-Gau/Octache/actions/workflows/octave_test_and_coverage.yml
   :alt: Octave: test and coverage

.. image:: https://github.com/Remi-Gau/Octache/actions/workflows/matlab_test_and_coverage.yaml/badge.svg
   :target: https://github.com/Remi-Gau/Octache/actions/workflows/matlab_test_and_coverage.yaml
   :alt: MATLAB: test and coverage

.. image:: https://codecov.io/gh/Remi-Gau/Octache/branch/main/graph/badge.svg?token=aFXb7WSAsm
   :target: https://codecov.io/gh/Remi-Gau/Octache
   :alt: codecov

.. image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :target: https://github.com/pre-commit/pre-commit
   :alt: pre-commit

.. image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/Remi-Gau/Octache/main
   :alt: Binder

.. image:: https://readthedocs.org/projects/octache/badge/?version=latest
   :target: https://octache.readthedocs.io/en/latest/?badge=latest
   :alt: Documentation Status


Welcome to the Octache documentation!
*************************************

Octave is an implementation of the `mustache templating language <http://mustache.github.io>`_
for Octave that also happen to work with MATLAB.

Installation
============

Dependencies
++++++++++++

To facilitate handling of JSON files, Octache uses the `JSONio library <https://github.com/gllmflndn/JSONio.git>`_.

For testing it also requires `the repository containing the mustache spec <https://github.com/mustache/spec>`_.

They are both set up as git submodules so the easiest way to install Octache is...

Using git
+++++++++

.. code-block:: bash

   git clone --recursive https://github.com/Remi-Gau/Octache.git

Set up
++++++

If you are using Octave you need to recompile JSONio::

   make install_octave

To add the relevant folders to Octave / MATLAB path for this session,
run the `setup.m`

USAGE
=====

If you want to render a string directly.

.. code-block:: matlab

   output = octache('"Hello {{value}}! {{who}}"', ...
                    'data', struct('value', 'world', ...
                                   'who', 'I am Octache'))

If you want to render the content of a file.

.. code-block:: matlab

   output = octache(path_to_file_to_render, ...
                   'data', path_data_JSON, ...
                   'partials_path', path_folder_with_partials, ...
                   'partials_ext', 'mustache', ...
                   'warn', true, ...
                   'keep', true);


---

.. toctree::
   :maxdepth: 0
   :caption: Table of content

   main_functions

Indices and tables
==================

* :ref:`genindex`
* :ref:`search`
