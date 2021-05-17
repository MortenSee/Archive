//This is my working directory; praise the localhost!

//Implementing the card game SET!
//
// a card object has 4 properties:
// shape, color, number and style
//each of these properties has 3 different variants
const shape=["oval", "rectangle", "wave"];
const color=["red", "blue", "green"];
const number=[1, 2, 3];
const style=["hatched", "fully colored", "outlined"];
//
//Our, for now, empty deck of cards
let deck=[];
//
let hand=[];
//
//setup function || needed to call the P5.js functions createCanvas() and others in displayHand()
function setup() {
  createCanvas(1200,1200);
  //let's build up our deck.
  deck=buildDeck();
  //and draw some cards
  hand=drawCards(12);
  // and draw them too while we are at it!
  displayHand();
}
//
//
class card {
  constructor(shape, color, number, style)
  {
    this.shape=shape;
    this.color=color;
    this.number=number;
    this.style=style;
  }
  
  display(x,y)  {
    let card_height=300;
    let card_width=200;
    let x_off = card_width/3;
    let y_off = card_height/2;
    fill(130);
    stroke(0);
    rect(x, y, card_width, card_height);
    textSize(32);
    fill(this.color);
    text(this.number.toString(), x+ x_off+ x_off/3, y+y_off/3);
    noFill();
    //draws the image on the card according to the shape property.
    //these use the hatched function if style == "hatched"
    if (this.shape == "wave") {
      stroke(this.color);
      (this.style =="fully colored")? fill(this.color):null;
      (this.style =="hatched")? hatched("wave",x,y):null;
      let arc_height=card_height/3;
      arc(x+ x_off, y+y_off, x_off, arc_height, PI, 0);
      arc(x+ 2*x_off, y+y_off, x_off, arc_height, 0, PI);
    }
    if (this.shape =="oval") {
      stroke(this.color);
      (this.style =="fully colored")? fill(this.color):null;
      (this.style =="hatched")? hatched("oval",x,y):null;
      let oval_width=card_height/3;
      let oval_height=card_height/2;
      ellipse(x+ x_off + oval_width/4, y+y_off, oval_width, oval_height);
      
    }
    if (this.shape == "rectangle") {
      stroke(this.color);
      (this.style =="fully colored")? fill(this.color):null;
      (this.style =="hatched")? hatched("rectangle",x,y):null;
      let rec_width=card_height/4;
      let rec_height=card_height/3;
      rect(x+ x_off- rec_width/10, y+y_off- rec_height/2, rec_width, rec_height);
      
    }
  }
}
//
//helper function for drawing the hatched versions of the shapes
function hatched(shape, x, y) {
  let card_height=300;
  let card_width=200;
  let x_off = card_width/3;
  let y_off = card_height/2;
  switch (shape) {
    //loops to draw a few more offset copies of the correct shape slightly below the original.
    case "oval":
    let oval_width=card_height/3;
    let oval_height=card_height/2;
    noFill();
    for (var i = 1; i <8; i++) {
      ellipse(x+ x_off + oval_width/4, y+y_off, oval_width -i*10 , oval_height -i*10);
    }
    break;
    
    case "rectangle":
    let rec_width=card_height/4;
    let rec_height=card_height/3;
    for (var i = 1; i <8; i++) {
      noFill();
      rect(x+ x_off- rec_width/10 +i*3, y+y_off- rec_height/2 +i*3, rec_width -i*6 , rec_height -i*6 );
    }
    
    break;
    
    case "wave":
    let arc_height=card_height/3;
    for (var i = 1; i < 8; i++) {
      noFill();
      arc(x+ x_off, y+y_off +i*4, x_off, arc_height, PI, 0);
      arc(x+ 2*x_off, y+y_off + i*4, x_off, arc_height, 0, PI);
    }
    break;
  }
}
//
//we need a function to check if we have a set, i.e. out of 3 cards for each attribute it's either the same for each
//or different for each card.
function checkSet(c1,c2,c3) {
  //split for readabilty
  let shapeSet= (c1.shape==c2.shape)? ((c2.shape==c3.shape)? true:false):((c1.shape != c3.shape) && (c2.shape != c3.shape))? true:false;
  let colorSet= (c1.color==c2.color)? ((c2.color==c3.color)? true:false):((c1.color != c3.color) && (c2.color != c3.color))? true:false;
  let numberSet= (c1.number==c2.number)? ((c2.number==c3.number)? true:false):((c1.number != c3.number) && (c2.number != c3.number))? true:false;
  let styleSet= (c1.style==c2.style)? ((c2.style==c3.style)? true:false):((c1.style != c3.style) && (c2.style != c3.style))? true:false;
  return (shapeSet && colorSet && numberSet && styleSet);
  //you could make it faster by computing the statements one after another by using the statement below
  //with the lines above c&p in instead of always computing each
  //(shapeSet)? ((colorSet)? ((numberSet)? ((styleSet)? true:false):false):false):false
}
//a quick wrapper for a triplet of cards given as an array of card objs.
function checkSetFromArray(arr) {
  return checkSet(arr[0],arr[1],arr[2]);
}

//now that we have the basics let's build our deck, there is exactly one card for each constellation of properties
//that makes 81 in total
function buildDeck() {
  let shape=["oval", "rectangle", "wave"];
  let color=["red", "blue", "green"];
  let number=[1, 2, 3];
  let style=["hatched", "fully colored", "outlined"];
  let deck=[];
  //easy itteration through all the possibilties
  //doesnt look that great but gets the job done fast
  for (var i = 0; i < shape.length; i++) {
    for (var j = 0; j < color.length; j++) {
      for (var k = 0; k < number.length; k++) {
        for (var l = 0; l < style.length; l++) {
          deck.push(new card(shape[i], color[j], number[k], style[l]));
        }
      }
    }
  }
  return deck;
}
//now we can fill the deck with the buildDeck() fn.
//(done in setup)

//a game of SET! is played by drawing 12 cards and trying to make SETs with those
//so let#s draw n cards
//
function drawCards(n) {
  let hand=[];
  let drawn={};
  while(hand.length<n) {
    //0 and 81 have half the chance of every other card but this way is good enough to get some cards for now.
    let index= Math.floor(Math.random()*81);
    //we dont want duplicate cards so we use the drawn obj. to check if we already have that card in our hand
    (drawn[index]==undefined)? hand.push(deck[index]):null;
    console.log(index);
    //after drawing a card we add it's index as a key to the drawn obj.
    //the value doesnt matter as long as it's not undefined.
    drawn[index]=1;
  }
  return hand;
}

//now we need to draw 12 cards.
//(done in setup)

//lastly we have to check every possible combination of 3 cards for a SETs
//for that we need all possible triplets of cards and filter with checkSet()
//powerset function off of stackexchange uses the mathematical approach that
//for each element of the pwr set each elt of the set is either in it or not in it and
//construct the subsets accordingly
function powerset(l) {
  return (function ps(list) {
    if (list.length === 0) {
      return [[]];
    }
    var head = list.pop();
    var tailPS = ps(list);
    return tailPS.concat(tailPS.map(function(e) { return [head].concat(e); }));
  })(l.slice());
}
//
// A function that returns all the subsets of hand that contain 3 cards that form a SET
function getSets(hand) {
  //filters the powerset to those who are of length 3 AND are a SET via the checkSetFromArray() fn.
  return powerset(hand).filter((arr) => ((arr.length==3)? ((checkSetFromArray(arr))? true:false):false));
}

//and now we could draw them all!
//A Function that draws all the cards in the hand variable
function displayHand() {
  for (var i = 0; i < hand.length; i++) {
    let x= (Math.floor(i/3))*200;
    let y= 300 * (i%3);
    hand[i].display(x,y);
  }
}
// TODO Draw SETs differently than other cards || outline the cards belonging to a SET in the current hand with different colors for each SET
// simpler version : draw a tiny "SET! - N" in each of the cards belonging to the N-th SET (upper left hand corner or something)
