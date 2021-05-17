//Mal schauen was ich als erstes machen...

//Excercise 02
//2.1 faktorial--recursive
function faktorial(x)
{
  return x === 1 ? x : x*faktorial(x-1);
}
//console.log(faktorial(5));

//2.2 a recursive power function... should replace the Math.power with a multiplication tbh
function power(base,exponent)
{
  return exponent === 0 ? 1 : (exponent % 2) === 0 ? Math.pow(power(base,exponent/2), 2) : base*power(base,exponent-1);
}
//console.log(power(2,8));

//2.3 calculate e
function calcEuler(margin) {
  let e=1;
  let a=2;
  let step=a/faktorial(a-1);
  while (step>1/margin) {
    e+=step;
    a++;
    step=a/faktorial(a-1);
  }
  return e/2;
}
//console.log(calcEuler(1000000));

//2.3 calculate PI with the Leibniz sum.
function calcPi(margin) {
  let pi=1;
  let a=3;
  let step= -1/a;
  let count=1;
  while (Math.abs(step)>1/margin) {
    pi+=step;
    a+=2;
    step= count/a;
    count*=-1;
  }
  return pi*4;
}
// console.log(calcPi(100000000));

//3.1 datastructure for the international flag alphabet
let flag_table= {
  a:"Alpha",
  b:"Bravo",
  c:"Charlie",
  d:"Delta",
  e:"Echo",
  f:"Foxtrot",
  g:"Golf",
  h:"Hotel",
  i:"India",
  j:"Juliet",
  k:"Kilo",
  l:"Lima",
  m:"Mike",
  n:"November",
  o:"Oscar",
  p:"Papa",
  q:"Quebec",
  r:"Romeo",
  s:"Sierra",
  t:"Tango",
  u:"Uniform",
  v:"Viktor",
  w:"Whiskey",
  x:"X-ray",
  y:"Yankee",
  z:"Zulu",
  0:"Nadazero",
  1:"Unaone",
  2:"Duotwo",
  3:"Terrathree",
  4:"Carrefour",
  5:"Pentafive",
  6:"Soxisix",
  7:"Setteseven",
  8:"Oktoeight",
  9:"Novonine",
  ",":"Decimal",
  ".":"Stop"
}
//assoc : get the val of the key:value pair out of the provided table variable
function assoc(table,key) {
  let real_key = key.toLowerCase();
  return table[real_key];
}
function spellMessage(message) {
  let txtArr= Array.from(message);
  let txt= txtArr.map((item) => assoc(flag_table,item)).toString().replace(/,/gi," ");
  return txt;
}
