#!/bin/bash

bundle exec jekyll build
cp -R _site/* ../docs
