#!/bin/bash

mkdir /tmp/package
cd /app
tar cfvz /tmp/package/libs.tar.gz libs
tar cfvz /tmp/package/php.tar.gz php
tar cfvz /tmp/package/apache.tar.gz apache

cd /tmp/package
tar cvfz /tmp/slug.tar.gz libs.tar.gz php.tar.gz apache.tar.gz
