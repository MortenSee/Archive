
//Graphic stuff | P5 library
//drawing a bunch of circles :)
function setup()
{
  createCanvas(600,600);
  background(55);
  drawCircles(36,50,0,0,0,1);
}
let rad=250;
function draw()
{
  noFill();
  let col1=color('blue');
  translate(300,300);
  ellipse(0,0,rad,rad);
  strokeWeight(4);
  stroke(col1);
}
function drawCircles(num,rad,startX,startY,dir) {
  let circles=[];
  let radOff=1;
  translate(300,300);
  for (var i = 0; i < num; i++) {
    let col= color((i*12)%255,20,20);
    noFill();
    stroke(col);
    strokeWeight(4);
    let circle = ellipse(startX+rad*cos(i*17),startY+rad*sin(i*17),rad,rad);
    rad+=radOff;
    radOff += 1;
    circles.push(circle);
  }
  return circles;
}
