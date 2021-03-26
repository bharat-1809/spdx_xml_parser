#!/bin/bash
set -e

# So that users can run this script from anywhere and it will work as expected.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR"/spdx_xml_parser)"

# Dart needs to be in the path already...
(cd ${REPO_DIR}; pub get)
(cd ${REPO_DIR}; dart run)