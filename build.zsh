#!/bin/zsh -e

# https://www.w3schools.com/css/css_rwd_viewport.asp

# gshuf -n 1 -i 2000000000-2999999999

source /usr/local/share/homebrew/compat.zshrc

INDENT="  "
ITEMS=""

O=tmp.httpd

# $1=CHECKSUM $2=EXTNAME $3=TITLE
f(){

    # 1/3 append to index html
    ITEMS+=$(echo "$INDENT$INDENT$INDENT<a href='$1.html'>$3</a><br/>")

    # 2/3 generate song html
    SONG=$(cat song.in.html)
    SONG=${SONG//@SHA@/$1}
    SONG=${SONG//@EXT@/$2}
    SONG=${SONG//@TITLE@/$3}
    SONG=${SONG//@LRC@/$(calc/calc.out <RES/$1.txt)}
    echo $SONG >$O/$1.html

    # 3/3 copy track
    cp -vi RES/$1.$2 $O/

}

main(){

    # creat path
    rm -rfv $O
    mkdir -pv $O

    # add songs
    f "9f0a745a8cf7105c9a9781dfcce4d75e815ca18c" m4a "뱀파이어"
    f "997ece244071b3c83e5932b3ffe4620912dd290e" m4a "레몬"

    # collect index
    INDEX=$(cat index.in.html)
    INDEX=${INDEX//@I6DZF1@/$ITEMS}
    echo $INDEX >$O/index.html

    # aux files
    cp -vi *.{css,js,ttf} $O/
    rsgain easy $O

}

main; exit
