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
    ITEMS+=$'\n'
    ITEMS+=$(echo "$INDENT$INDENT$INDENT<a href='$1.html'>$3</a><br/>")

    # 2/3 generate song html
    SONG=$(cat song.in.html)
    SONG=${SONG//@SHA@/$1}
    SONG=${SONG//@EXT@/$2}
    SONG=${SONG//@TITLE@/$3}
    echo compiling $1 $3 ...
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
    f "bf599404b88058535f53b2aadb9baf8e65287f37" m4a  "군청"
    f "b9b39fcfcd66c7d979f718343c13eaa05e18cc4f" m4a  "귀여워서 미안해"
    f "997ece244071b3c83e5932b3ffe4620912dd290e" m4a  "레몬"
    f "9f0a745a8cf7105c9a9781dfcce4d75e815ca18c" m4a  "뱀파이어"
    f "60c0b184054626b5face242d38b4c1c608dbe0b3" m4a  "블루버드"
    f "869a09ea5562b53007272437e61b0eb8f41b1ccf" m4a  "빛난다면"
    f "6b3afab81b1e852152c61f0b66fac1a35b71b0a2" m4a  "예수 안에 소망 있네"
    f "35fe4e3911d7c9aeb6c7ab6edb63d3afa02bb830" flac "우아하게"
    f "1038fa30ac06258ff00fd45853487fc6f7bb9ac2" flac "큐피드"
    f "06dde3b007897cb6fc42af8ed560474149622110" m4a  "홍련화"
    f "8ca3183cd82ffb208776764dcb77e12b2bd2cf0b" flac "힙"

    # collect index
    INDEX=$(cat index.in.html)
    INDEX=${INDEX//@I6DZF1@/$ITEMS}
    echo $INDEX >$O/index.html

    # aux files
    cp -vi Makefile *.{css,js,ttf} $O/
    rsgain easy $O

}

main; exit
