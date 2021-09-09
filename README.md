# README

## This project uses...

- [Coffeescript](http://coffeescript.org/) for javascript.
- [Sass](http://sass-lang.com/) for css.
- [Foundation](http://foundation.zurb.com/sites/docs) for responsive design.
- [Font Awesome](http://fontawesome.io/icons/) for icons.
- [Chart.js](http://www.chartjs.org/) for graphs.

## Setup

### Download Project
```
$ git clone git@github.com:EnVisageConsulting/timelog.git
```
<small><b>Note:</b> Run the following set up commands inside the newly created project directory (`cd timelog`).</small>

### Ruby
This project uses ruby `2.6.6`. Make sure you are on the right ruby version:

```
$ ruby -v
> ruby 2.6.6p146
```

### Install Gems

```
$ bundle install
```

### Database
We use PostgreSQL for the database. Ensure that you have it installed:

```
$ psql --version
> psql (PostgreSQL) 9.5.3
```

Make a local copy of your database configuration (database.yml):

```
$ cp config/database.yml.copy config/database.yml
```

Now, you can create your database:

```
$ rake db:setup
```
<small>**Note:** The `db:setup` task will include seed data. Run `rake db:create` and `rake db:migrate` if you want to create the database without seed data.</small>

### Rails

Start a rails server:

```
$ rails s
```

Now you can navigate to `localhost:3000` to view your changes/files served locally.

## Test Suite
This project uses **RSpec** for the testing framework.

If you've made changes or are in the process of making them, make sure we have a passing test suite *prior* to pushing changes to `master`.

To run the whole suite:

```
$ bin/rspec
> ...
> Finished in 1.35 seconds (files took 3.65 seconds to load)
> 81 examples, 0 failures, 2 pending
```

Or, for a specific file:

```
$ bin/rspec spec/models/log_spec.rb
> ...
> Finished in 0.73682 seconds (files took 3.61 seconds to load)
> 27 examples, 0 failures
```

