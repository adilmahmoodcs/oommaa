# Counterfind

Production address: http://dev.counterfind.com/
Staging address: http://demo.counterfind.com/

## Development setup

### Frontend app

Install PostgreSQL (see `config/database.yml`)
Install ruby 2.4.0
Run:

    bundle
    bin/rake db:setup
    guard

Visit http://localhost:3000/
Log in as admin@example.com / password

### Background jobs

Install Redis
To start background processing:

    sidekiq -C config/sidekiq.yml

WARNING: This will start processing hundreds of ads.

Token configuration is on `config/counterfind.yml`
NOTE: make sure there's a VALID facebook token for the development environment

The sidekiq interface is at http://localhost:3000/sidekiq

### Production database

A daily Postgres backup dump of the production database is available on the S3
bucket "counterfind-production-backups"

## Running tests

    bin/rails db:test:prepare # only first time
    bin/rspec spec

## Deploy

Note: you must have a valid ssh key for the server's `deployer` user.

    cap <stage> deploy

The `master` branch is deployed on staging, the `production` branch is deployed
on production.

## Open a console on the server

    cap <stage> rails:console
