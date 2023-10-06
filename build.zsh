#!/bin/zsh -e

# https://www.w3schools.com/css/css_rwd_viewport.asp

# gshuf -n 1 -i 2000000000-2999999999

source /usr/local/share/homebrew/compat.zshrc

INDENT="    "

OUT=tmp.httpd

index_1(){
cat <<EOF
<!DOCTYPE html>
<html lang=ko-KR>
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=10.0">
    </head>
    <body>
EOF
}

html_end(){
cat <<EOF
        <script>

            // document.cookie = "fontSize=60; SameSite=None; Secure; max-age=31536000";
            // document.cookie = "lineHeight=100; SameSite=None; Secure; max-age=31536000";
            // console.log(document.cookie);

            // set default
            fontSizeMin = 55;
            fontSizeTyp = 60;
            fontSizeMax = 65;
            fontSize = fontSizeTyp;
            lineHeightMin = 70;
            lineHeightTyp = 100;
            lineHeightMax = 150;
            lineHeight = lineHeightTyp;
            function limit(v, min, typ, max){
                console.log(v)
                if(min <= v && v <= max){
                    return v;
                }else if(v < min){
                    return min;
                }else if(max < v){
                    return max;
                }else{
                    return typ;
                }
            }

            // get cookie
            spl = document.cookie.split("; ")
            // if(spl.some((i) => i.trim().startsWith("fontSize="))) {
            //     fontSizeStr=spl
            //         .find((row) => row.startsWith("fontSize="))
            //         ?.split("=")[1];
            //     fontSize = parseInt(fontSizeStr);
            // }
            // if(spl.some((i) => i.trim().startsWith("lineHeight="))) {
            //     lineHeightStr=spl
            //         .find((row) => row.startsWith("lineHeight="))
            //         ?.split("=")[1];
            //     lineHeight = parseInt(lineHeightStr);
            // }
            fontSizeStr=spl
                .find((row) => row.startsWith("fontSize="))
                ?.split("=")[1];
            lineHeightStr=spl
                .find((row) => row.startsWith("lineHeight="))
                ?.split("=")[1];
            fontSize = limit(parseInt(fontSizeStr), fontSizeMin, fontSizeTyp, fontSizeMax);
            lineHeight = limit(parseInt(lineHeightStr), lineHeightMin, lineHeightTyp, lineHeightMax);

            // apply settings from cookie or default
            // e.style.fontSize = (parseInt(getComputedStyle(e).fontSize) - 1) + "px"
            const es = document.querySelectorAll("p:nth-child(n+3)");
            es.forEach((e) => { e.style.fontSize = fontSize + "px"; });
            es.forEach((e) => { e.style.lineHeight = lineHeight + "%"; });

            // (1) change
            // (2) apply
            // (3) save
            function fs_dec(){
                fontSize = fontSize - 1
                fontSize = limit(fontSize, fontSizeMin, fontSizeTyp, fontSizeMax);
                es.forEach((e) => { e.style.fontSize = fontSize + "px"; });
                document.cookie = \`fontSize=\${fontSize}; SameSite=None; Secure; max-age=31536000\`;
            }

            function fs_inc(){
                fontSize = fontSize + 1
                fontSize = limit(fontSize, fontSizeMin, fontSizeTyp, fontSizeMax);
                es.forEach((e) => { e.style.fontSize = fontSize + "px"; });
                document.cookie = \`fontSize=\${fontSize}; SameSite=None; Secure; max-age=31536000\`;
            }

            function lh_dec(){
                lineHeight = lineHeight - 10
                lineHeight = limit(lineHeight, lineHeightMin, lineHeightTyp, lineHeightMax);
                es.forEach((e) => { e.style.lineHeight = lineHeight + "%"; });
                document.cookie = \`lineHeight=\${lineHeight}; SameSite=None; Secure; max-age=31536000\`;
            }

            function lh_inc(){
                lineHeight = lineHeight + 10
                lineHeight = limit(lineHeight, lineHeightMin, lineHeightTyp, lineHeightMax);
                es.forEach((e) => { e.style.lineHeight = lineHeight + "%"; });
                document.cookie = \`lineHeight=\${lineHeight}; SameSite=None; Secure; max-age=31536000\`;
            }

        </script>
    </body>
</html>
EOF
}

# $1=CHECKSUM $2=EXTNAME $3=TITLE
song_1(){
cat <<EOF
<!DOCTYPE html>
<html lang=ko-KR>
    <head>
        <meta charset="utf-8"/>
        <!-- https://www.w3schools.com/css/css_rwd_viewport.asp -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" type="image/png" href="data:image/png;base64,iVBORw0KGgo=">
        <title>$3</title>
        <style>
            @font-face {
                font-family: "Gamja Flower";
                src: url(GamjaFlower-Regular.ttf);
            }
            p:nth-child(n+3) {
                text-indent: 0;
                font-family: "Gamja Flower", sans-serif;
            }
            button {
                font-family: monospace, sans-serif;
            }
            audio {
                width: 100%;
            }
        </style>
    </head>
    <body>
        <p>
            <button onClick="fs_dec()">font-=1px</button> <button onClick="lh_dec()">lineHeight-=10%*lh0</button><br/>
            <button onClick="fs_inc()">font+=1px</button> <button onClick="lh_inc()">lineHeight+=10%*lh0</button><br/>
        </p>
        <p>
            <audio controls preload src="$1.$2" type="audio/$2"></audio>
        </p>
EOF
}

# $1=CHECKSUM $2=EXTNAME $3=TITLE
f(){
    # 1/3 append to index html
    echo "$INDENT$INDENT<a href='$1.html'>$3</a><br/>" >>$OUT/index.html
    # 2/3 generate song html
    {
        song_1 $@
        calc/calc.out <RES/$1.txt
        html_end
    } >$OUT/$1.html
    # 3/3 copy track
    cp -vi RES/$1.$2 $OUT/
}

main(){

    # creat path
    rm -rfv $OUT
    mkdir -pv $OUT

    # create index html
    index_1 >>$OUT/index.html

    # add songs
    f "9f0a745a8cf7105c9a9781dfcce4d75e815ca18c" m4a "뱀파이어"
    f "997ece244071b3c83e5932b3ffe4620912dd290e" m4a "레몬"

    rsgain easy $OUT

    # complete index html
    html_end >>$OUT/index.html

    # copy font
    cp -vi RES/*.ttf $OUT/

}

main; exit
