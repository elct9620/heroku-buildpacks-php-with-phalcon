Heroku Buildpack - PHP with PhalconPHP
===

For phalcon user on heroku, easy deploy their phalcon app.

Usage
---

Just using `heroku create APP_NAME -b https://github.com/elct9620/heroku-buildpacks-php-with-phalcon` to start your phalcon heroku app.

### Specify your package source

#### Require

Enable heroku [user-env-compile](https://devcenter.heroku.com/articles/labs-user-env-compile) addon. (This still is labs feature)

#### Usage

Using [profile.d](https://devcenter.heroku.com/articles/profiled) or `heroku config` command to setting `PACKAGE_URL` and you can use your special php pre-compile package.

(This feature sitll under test, it may not work correctly)

Build
---

### Require

* Heroku Vulcan
* A litle Shell Script Knowledge

### Howto

First, you may want modify `ext/build.sh` and setting up your PHP version and add some PHP extension.

When your already specify your version and extension, just run `ext/vulcan-build.sh` and it will auto run build and down packaged file to `/tmp`


