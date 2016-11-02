#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo $0: usage: plugin.sh name version
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NAME=$(echo $1|tr -dc '[[:alpha:]]')
LNAME=${NAME,,}
UNAME=${NAME^^}
VERSION=$2

DEST=$DIR/../$LNAME
echo $NAME

if [ -d "$DEST" ]; then
    echo "A directory named $LNAME already exists!"
    exit 1
fi

mkdir $DEST

rsync \
    --exclude '.git*' \
    --exclude 'plugin.sh' \
    --exclude 'dist' \
    -a . $DEST

pushd $DEST > /dev/null

#rename .tpl...
for f in `ls *.tpl`
do
    mv $f ${f%.*}
done

#do replacements
sed \
    -e "s/{NAME}/$NAME/" \
    -e "s/{LNAME}/$LNAME/" \
    -e "s/{UNAME}/$UNAME/" \
    -e "s/{VERSION}/$VERSION/" \
    -i setup.php hook.php tools/extract_template.sh tools/HEADER
popd > /dev/null
