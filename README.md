## Why gitpillage? ##
I thought it would be useful to automate some other techniques I found to extract code, configs and other information from a git repo identified in a web root that was not 100% cloneable. Gitpillage extracts as much knowledge about the repo as possible through predictable file names and known object hashes.


## Requirements ##

Basic requirements usually fulfilled by any *nix system.

* bash
* wget or curl
* grep
* awk


## Usage ##
    gitpillage.sh hostname/directory
    (directory is optional)

Example:

    `gitpillage.sh www.example.com/images (would crawl http://example.com/images/.git/)`

    `gitpillage.sh www.example.com (would crawl http://example.com/.git/)`


Edit `gitpillage.sh` and set the `host` variable near the top of script. If the git repo is in a sub directory set that in the `dir` then run `./gitpillage.sh`

## Contributors ##
@wraithgar

## License ##

Written by [Adam Baldwin](http://github.com/evilpacket).
Copyright © 2011 by nGenuity Information Services, LLC. Released under the terms of the MIT License:

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
