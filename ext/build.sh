#!/bin/sh

###
# Heroku Apache + PHP
# Version: 1.0
# Author: Aotoki
# HomePage: http://frost.tw
#
# History:
#   2012-11-05 First Create Project
###

# Settings

## Version
APACHE_VERSION=2.4.6
PHP_VERSION=5.5.5
LIBMCRYPT_VERSION=2.5.8
APR_VERSION=1.4.8
APR_UTIL_VERSION=1.5.2
LIBPCRE_VERSION=8.33
# Disable APC due PHP 5.5 using opcode
# APC_VERSION=3.1.13

## Download URL
APACHE_URL=http://www.us.apache.org/dist/httpd/httpd-${APACHE_VERSION}.tar.gz
PHP_URL=http://us.php.net/distributions/php-${PHP_VERSION}.tar.gz
MCRYPT_URL=http://downloads.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmcrypt%2F&ts=1352120606&use_mirror=nchc
MCRYPT_URL=http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/${LIBMCRYPT_VERSION}/libmcrypt-${LIBMCRYPT_VERSION}.tar.gz
APR_URL=http://www.us.apache.org/dist/apr/apr-${APR_VERSION}.tar.gz
APR_UTIL_URL=http://www.us.apache.org/dist/apr/apr-util-${APR_UTIL_VERSION}.tar.gz
PCRE_URL=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${LIBPCRE_VERSION}.tar.gz
# APC_URL=http://pecl.php.net/get/APC-${APC_VERSION}.tgz

PHALCON_REPO=git://github.com/phalcon/cphalcon.git

## PATH
BASE_DIR=/app
APACHE_ROOT=${BASE_DIR}/apache
PHP_ROOT=${BASE_DIR}/php
MCRYPT_ROOT=${BASE_DIR}/libs/mcrypt
PCRE_ROOT=${BASE_DIR}/libs/pcre

## DIR
APACHE_DIR=httpd-${APACHE_VERSION}
PHP_DIR=php-${PHP_VERSION}
MCRYPT_DIR=libmcrypt-${LIBMCRYPT_VERSION}
APR_DIR=apr-${APR_VERSION}
APR_UTIL_DIR=apr-util-${APR_UTIL_VERSION}
PCRE_DIR=pcre-${LIBPCRE_VERSION}
# APC_DIR=APC-${APC_VERSION}
PHALCON_DIR=cphalcon

## FLAGS
CURL_FLAGS="--silent --max-time 60 --location"

# Start Build
mkdir build
cd build

echo "[LOG] Staring Build"

## Download Necessary Library

### APACHE
echo "[LOG] Downloading apache-$APACHE_VERSION"
curl $CURL_FLAGS "$APACHE_URL" | tar zx
if [ ! -d "$APACHE_DIR" ]; then
  echo "[ERROR] Failed to find apache directory $APACHE_DIR "
fi

echo "[LOG] Downloading apr-$APR_VERSION"
curl $CURL_FLAGS "$APR_URL" | tar zx
if [ ! -d "$APR_DIR" ]; then
  echo "[ERROR] Failed to find apr directory $APR_DIR"
fi

echo "[LOG] Downloading aph-util-$APR_UTIL_VERSION"
curl $CURL_FLAGS "$APR_UTIL_URL" | tar zx
if [ ! -d "$APR_UTIL_DIR" ]; then
  echo "[ERROR] Failed to find apr-util directory $APR_UTIL_DIR"
fi

echo "[LOG] Downloading pcre-${LIBPCRE_VERSION}"
curl $CURL_FLAGS "$PCRE_URL" | tar zx
if [ ! -d "$PCRE_DIR" ]; then
  echo "[ERROR] Failed to find libpcre directory $PCRE_DIR"
fi

### PHP
echo "[LOG] Downloading php-${PHP_VERSION}"
curl $CURL_FLAGS "$PHP_URL" | tar zx
if [ ! -d "$PHP_DIR" ]; then
  echo "[ERROR] Failed to find php directory $PHP_DIR"
fi

# echo "[LOG] Downloading APC-{$APC_VERSION}"
# curl $CURL_FLAGS "$APC_URL" | tar zx
# if [ ! -d "$APC_DIR" ]; then
#   echo "[ERROR] Failed to find apc directory $APC_DIR"
# fi

### Libmcrypt
echo "[LOG] Downloading libmcrypt-${LIBMCRYPT_VERSION}"
curl $CURL_FLAGS "$MCRYPT_URL" | tar zx
if [ ! -d "$MCRYPT_DIR" ]; then
  echo "[ERROR] Failed to find libmcrypt directory $MCRYPT_DIR"
fi

### Phalcon
echo "[LOG] Downloading PhalconPHP"
git clone $PHALCON_REPO -q
if [ ! -d "$PHALCON_DIR" ]; then
  echo "[ERROR] Failed to find phalconphp directory $PHALCON_DIR"
fi

## Build

## PCRE
echo "[LOG] Building PCRE"
cd $PCRE_DIR
./configure --prefix=$PCRE_ROOT
make
make install
cd ..

## APACHE
echo "[LOG] Building Apache"
mv $APR_DIR $APACHE_DIR/srclib/apr
mv $APR_UTIL_DIR $APACHE_DIR/srclib/apr-util
cd $APACHE_DIR
./configure --prefix=$APACHE_ROOT --with-pcre=$PCRE_ROOT --enable-rewrite
make
make install
cd ..

## MCRYPT
echo "[LOG] Building MCrypt"
cd $MCRYPT_DIR
autoconf -W no-obsolete -W no-syntax
automake
./configure --prefix=$MCRYPT_ROOT
make
make install
cd ..

## PHP
echo "[LOG] Building PHP"
cd $PHP_DIR
./configure --prefix=$PHP_ROOT --with-config-file-path=$PHP_ROOT --with-apxs2=$APACHE_ROOT/bin/apxs \
  --with-mysql --with-pdo-mysql --with-pgsql --with-pdo-pgsql \
  --with-iconv --with-gd --with-curl --enable-soap=shared --with-openssl \
  --with-mcrypt=$MCRYPT_ROOT --with-jpeg-dir=/usr
make
make install
cd ..

## PEAR

/app/php/bin/pecl channel-update pecl.php.net

# echo "[LOG] Install PHP Extension: APC"
# cd $APC_DIR
# /app/php/bin/phpize
# ./configure --enable-apc --enable-apc-filehits --with-php-config=$PHP_ROOT/bin/php-config
# make && make install
# cd ..

echo "[LOG] Install PHP Extension: LUA"
/app/php/bin/pecl install lua

echo "[LOG] Install PHP Extension: Mongo"
/app/php/bin/pecl install mongo

## Phalcon
echo "[LOG] Install PHP Extension: PhalconPHP"
cd $PHALCON_DIR/build
# /app/php/bin/phpize
# ./configure --enable-phalcon --with-php-config=$PHP_ROOT/bin/php-config
# make
# make install
export PATH=$PATH:/app/php/bin
bash ./install
cd ../..

# Packaging
echo "[LOG] Packaging"
cd /app
mkdir package

tar -zcf libs.tar.gz libs
mv libs.tar.gz package/

echo "$APACHE_VERSION" > $APACHE_ROOT/VERSION
tar -zcf apache.tar.gz apache
mv apache.tar.gz package/

echo "$PHP_VERSION" > $PHP_ROOT/VERSION
tar -zcf php.tar.gz php
mv php.tar.gz package/

echo "[LOG] Finished"

