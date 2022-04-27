.. Octache documentation master file

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
