// document.cookie = "fontSize=60; SameSite=None; Secure; max-age=31536000";
// document.cookie = "lineHeight=100; SameSite=None; Secure; max-age=31536000";
// console.log(document.cookie);

// set default
fontSizeMin = 20;
fontSizeTyp = 30;
fontSizeMax = 60;
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
// if(spl.some((i) => i.trim().startsWith("fontSize="))){
  //     fontSizeStr=spl
  //         .find((row) => row.startsWith("fontSize="))
  //         ?.split("=")[1];
  //     fontSize = parseInt(fontSizeStr);
  // }
  // if(spl.some((i) => i.trim().startsWith("lineHeight="))){
  //     lineHeightStr=spl
  //         .find((row) => row.startsWith("lineHeight="))
  //         ?.split("=")[1];
  //     lineHeight = parseInt(lineHeightStr);
  // }
spl = document.cookie.split("; ");
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
// const es = document.querySelectorAll("p:nth-child(n+3)");
const es = document.querySelectorAll("p.lrlef9");
es.forEach((e) => { e.style.fontSize = fontSize + "px"; });
es.forEach((e) => { e.style.lineHeight = lineHeight + "%"; });

function show(){
  document.getElementById("l0sbbf").value=(document.cookie);
  // alert(document.cookie);
}

// (1) change
// (2) apply
// (3) save
function fs_dec(){
  fontSize = fontSize - 1
  fontSize = limit(fontSize, fontSizeMin, fontSizeTyp, fontSizeMax);
  es.forEach((e) => { e.style.fontSize = fontSize + "px"; });
  document.cookie = `fontSize=${fontSize}; max-age=31536000`;
}

function fs_inc(){
  fontSize = fontSize + 1
  fontSize = limit(fontSize, fontSizeMin, fontSizeTyp, fontSizeMax);
  es.forEach((e) => { e.style.fontSize = fontSize + "px"; });
  document.cookie = `fontSize=${fontSize}; max-age=31536000`;
}

function lh_dec(){
  lineHeight = lineHeight - 10
  lineHeight = limit(lineHeight, lineHeightMin, lineHeightTyp, lineHeightMax);
  es.forEach((e) => { e.style.lineHeight = lineHeight + "%"; });
  document.cookie = `lineHeight=${lineHeight}; max-age=31536000`;
}

function lh_inc(){
  lineHeight = lineHeight + 10
  lineHeight = limit(lineHeight, lineHeightMin, lineHeightTyp, lineHeightMax);
  es.forEach((e) => { e.style.lineHeight = lineHeight + "%"; });
  document.cookie = `lineHeight=${lineHeight}; max-age=31536000`;
}

function fn_on(){
  const dE = document.documentElement;
  if (dE.requestFullscreen){
    dE.requestFullscreen();
  }else if(dE.webkitRequestFullscreen){
    dE.webkitRequestFullscreen();
  }else if(dE.msRequestFullscreen){
    dE.msRequestFullscreen();
  }
}

function fn_off(){
  if(document.exitFullscreen){
    document.exitFullscreen();
  }else if(document.webkitExitFullscreen){
    document.webkitExitFullscreen();
  }else if(document.msExitFullscreen){
    document.msExitFullscreen();
  }
}
