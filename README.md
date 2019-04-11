# FrontEnd

### Local Installation

To simplify installation and configuration the application and its dependencies are handled with Docker Compose. Docker Compose installation instructions for Mac, Linux and Windows are [here](https://docs.docker.com/compose/install/).

Docker & DockerCompose Versions

* Docker ~18
* DockerCompose ~1.2

With the above software installed you can spin it up simply with:

```bash
$ cd /path/to/rails-challenge
$ docker-compose build
$ docker-compose up
```

To access the command line of the docker container and migrate the database open another terminal tab or window and run:

```bash
$ docker-compose exec rails bash
$ rake db:setup
```

<br>

### Windows Installation Issues

If you have any trouble with the docker installation on Windows you can do the following as an alternative:

### Change Database Config

In the `config/database.yml` file invert the commented code and the uncommented code.

### Postgres

#### 1) Fire up Postgres and its cli

```bash
$ pg_ctl -D /usr/local/var/postgres start
$ psql postgres
```

#### 2) Create Database

Create database user role with create db ability and password

```bash
# Create user
$ createuser mediazilla_interview --createdb --pwprompt
$ Enter password for new role: XXXXXX # enter db password of interview
$ Enter it again: XXXXXX # enter db password of interview

#Create DB
$ createdb mediazilla_interview_development -U mediazilla_interview
```

### Ruby

#### 1) Install RVM

https://rvm.io/rvm/install

#### 2) Install Ruby Version

Use RVM to install a ruby version

```bash
$ rvm install 2.5.1
```

#### 2) Create Gemset

Create an empty gemset, check it out and make it the default gemset

```bash
$ rvm use 2.5.1@mediazilla --create --default
```

#### 3) Install Bundler

```bash
$ gem install bundler
```

#### 4) Install Server Dependencies

```bash
$ cd /path/to/rails_api

# Install dependencies
$ bundle

# Migrate the database
$ rake db:setup db:migrate

# Fire it up!
$ rails s # or bundle exec rails server
```

You will now have the server running exposed on http://localhost:3000
