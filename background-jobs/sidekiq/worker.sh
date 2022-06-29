#!/bin/sh

sidekiq -r './background-jobs/sidekiq/server.rb' -c 4
