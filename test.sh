#!/bin/bash

# Fast fail the script on failures
set -e

# Install coverage
pub global activate coverage

# Collect coverage:
PORT=9292

echo "Collecting coverage on port $PORT..."

# Start tests in one VM
dart --disable-service-auth-codes \
    --enable-vm-service=$PORT \
    --pause-isolates-on-exit \
    test/test_all.dart &

# Run the coverage collector to generate the JSON coverage report
pub global run coverage:collect_coverage \
    --port=$PORT \
    --out=coverage/coverage.json \
    --resume-isolates \
    --wait-paused

echo "Generating lcov report..."
pub global run coverage:format_coverage \
    --lcov \
    --packages=.packages \
    --in=coverage/coverage.json \
    --out=coverage/lcov.info \
    --report-on=lib \
    --check-ignore

