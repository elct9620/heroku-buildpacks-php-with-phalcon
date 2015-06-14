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

* A litle Shell Script Knowledge

### Howto

First, you may want modify `ext/build.sh` and setting up your PHP version and add some PHP extension.

* `heroku run bash` to connect your heroku binary build app
* `curl https://raw.github.com/elct9620/heroku-buildpacks-php-with-phalcon/develop/ext/build.sh` download the build script (or from your github )
* `chmod +x build.sh`
* `./build.sh` run build script and wait
* `cd build/`
* `tar -zcf package.tar.gz apache.tar.gz php.tar.gz libs.tar.gz` package all necessary files
* using "SCP" or other method to copy this package to remote server where your heroku app can access this package
  ( I using `curl -k -T package.tar.gz http://myNAS-Webdav-Endpoint/` to download this file)

### Dockerfile

Since Heroku support [docker](https://blog.heroku.com/archives/2015/5/5/introducing_heroku_docker_release_build_deploy_heroku_apps_with_docker), I plan migrate this buildpacks to docker version.

But Heroku didn't build slug, and cause the `docker:release` command spend a lot time to upload slug (about 49MB) so I will mantaince this project, and provide Dockerfile for contribute this project.

Now, the latest Dockerfile was added, and the buildpacks will update as soon as possible to use the latest build.
