#!/bin/bash

sphinx-build -M latexpdf source build

cp build/latex/mashlab.pdf mashlab.pdf
