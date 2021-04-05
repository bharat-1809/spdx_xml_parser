#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR"/spdx_xml_parser)"

(cd ${REPO_DIR}; pub get)
(cd ${REPO_DIR}; dart run)