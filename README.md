# Counterfind

## Development setup

Requirements: PostgreSQL, Redis (only for sidekiq)

Install ruby 2.4.0

    bundle
    bin/rake db:setup
    guard

## Run tests

    bin/rails db:test:prepare # first time
    bin/rspec spec

## Deploy

Note: you must have a valid ssh key for the server's `deployer` user.

    cap <stage> deploy

### Open a console on the server

    cap <stage> rails:console
