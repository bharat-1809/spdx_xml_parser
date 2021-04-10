# SPDX XML License Parser

[![CI](https://github.com/bharat-1809/spdx_xml_parser/actions/workflows/main.yml/badge.svg)](https://github.com/bharat-1809/spdx_xml_parser/actions/workflows/main.yml)
[![codecov](https://codecov.io/gh/bharat-1809/spdx_xml_parser/branch/main/graph/badge.svg)](https://codecov.io/gh/bharat-1809/spdx_xml_parser)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Fetches the license using the identifier entered by the user. Prints the license details to the terminal and the licene itself

## Working

- Fetches the license from the SPDX master list.
- Gets the license details like name, isOSiAprroved, and isDeprecated.
- Normalize the license:
    - Replace symbol codes with literal symbols.
    - Remove xml tags/nodes
    - Remove extraneous white spaces
- Prints the normalized license text

## Usage

- For Linux/ MacOS:&nbsp;```./spdx_parser.sh```

- For Win or if the above command doesn't work:&nbsp;```dart run```

## Test

- For running tests:&nbsp;```dart test```

- For generating coverage report:&nbsp;```./test.sh```

## Demo

<img src="https://raw.githubusercontent.com/bharat-1809/spdx_xml_parser/main/spdx_parser.gif">