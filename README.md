Heroku Buildpack - PHP with PahlconPHP
===

Install
---

Just using `heroku create APP_NAME -b git@github.com:elct9620/heroku-buildpacks-php-with-phalcon.git` to start your phalcon heroku app.

### Specify your package source

Using [profile.d](https://devcenter.heroku.com/articles/profiled) or `heroku config` command to setting `PACKAGE_URL` and you can use your special php pre-compile package.

(This feature sitll not test, it may not work correctly)

Build
---

### Require

* Heroku Vulcan
* A litle Shell Script Knowledge

### Howto

First, you may want modify `ext/build.sh` and setting up your PHP version and add some PHP extension.

When your already specify your version and extension, just run `ext/vulcan-build.sh` and it will auto run build and down packaged file to `/tmp`


