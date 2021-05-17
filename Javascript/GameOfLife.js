
//Excercise 07 : Game of life

//the dimension of a cell | used to draw the board and calculate how many cells are the in the game.
const px_size=5;
//the width of the canvas
const width=600;
//the height of the canvas
const height=600;
//the number of cells in a row.
const width_box_count=width/px_size;
//the number of cells in one column
const height_box_count=height/px_size;
//An Array to model the game; it contains all the cell objs.
let gamestate=Array(width_box_count*height_box_count);

//the P5.js's setup and draw function, the is constantly looping.
function setup()
{
  createCanvas(width,height);
  populate();
  background(25);
  frameRate(60);
  //starts the display with the r-pentomino exaple from wikipedia
  startFigure(1);
}
function draw() {
  drawGame();
  calcNextState();
}

//a class to manage the state of a cell in the Game of Life
class cell {
  //x: int--x position , y: int--y position , isAlive: boolean--true if alive.
  constructor(x,y,isAlive)
  {
    this.x=x;
    this.y=y;
    this.isAlive=isAlive;
  }
  //draws a square at the cell's (x,y) location. Black if it's alive, grey-ish if not.
  display() {
    noStroke();
    this.isAlive? fill(0):fill(175);
    rect(this.x,this.y,px_size,px_size);
  }
  //swaps the isAlive state of the cell.
  switchState() {
    this.isAlive= this.isAlive? false:true;
  }
}

//fills the array with cell objs.
function populate() {
  for (var i = 0; i <width_box_count; i++)
  {
    for (var j = 0; j < height_box_count; j++) {
      let random_boolean = Math.random() >= 0.5;
      gamestate[i+j*height_box_count]=new cell(i*px_size,j*px_size,random_boolean);
    }
  }
}

//calls the display function of the cell class for each cell present in the game.
function drawGame() {
  for (elts of gamestate) {
    elts.display();
  }
}

//counts the number of alive neighbors for the provided cell obj.
function countAliveNeighbors(cell) {
  let pos_x= cell.x/px_size;
  let pos_y= cell.y/px_size;
  //the cells own index | this is needed to not count oneself as a neighbor in the following loop
  let me= (pos_x) + (pos_y)*height_box_count;
  let aliveNeighbors=0;
  for (var i = -1; i <= 1; i++) {
    for (var j = -1; j <= 1; j++) {
      //modulo to connect the edges of the board | requires to add the dim to avoid a negative index for the left hand side of the board.
      let index= ((width_box_count + pos_x + i)%width_box_count) + ((height_box_count + pos_y + j)%height_box_count)*height_box_count;
      //if the calculated index isnt the cell that was given as an argument, we add 1 if the neighbor's isAlive is true, and do nothing otherwise.
      (index != me)? (gamestate[index].isAlive? aliveNeighbors+=1:null):null;
    }
  }
  //lastly we return the number of alive Neighbors.
  return aliveNeighbors;
}

function calcNextState() {
  //a copy to not overwrite the actual game while looking up neighbors
  //let copygame=JSON.parse(JSON.stringify(gamestate));
  let neighbors=0;
  let reborn=[];
  let willDie=[];
  for (var i = 0; i < gamestate.length; i++) {
    //count the alive Neighbors for each cell in the game
    neighbors=countAliveNeighbors(gamestate[i]);
    //if the cell is alive it needs
    if (gamestate[i].isAlive) {
      if (!(neighbors==2 || neighbors==3)) {
        willDie.push(i);
      }
    } else if(!gamestate[i].isAlive) {
      if (neighbors===3) {
        reborn.push(i);
      }
    }
  }
  for (elts of willDie) {
    gamestate[elts].switchState();
  }
  for (elts of reborn) {
    gamestate[elts].switchState();
  }
}

//a function to start an interesting configuration centered on the gameboard
//0 a simple flipper
//1 the r-pentomino state
function startFigure(num) {
  //the middle-most index of the game
  let middle=(width_box_count/2)+(width_box_count/2)*width_box_count;
  //every cell is dead except for...
  for (elts of gamestate) {
    elts.isAlive=false;
  }
  //the one specified by the given parameter
  switch (num) {
    case 0:
    //a simple flipper
    gamestate[middle-width_box_count].isAlive=true;
    gamestate[middle+width_box_count].isAlive=true;
    gamestate[middle].isAlive=true;
    break;
    case 1:
    // [a picture of the constellation](https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/R-PENTOM_r-Pentomino.svg/120px-R-PENTOM_r-Pentomino.svg.png)
    gamestate[middle].isAlive=true;
    gamestate[middle-width_box_count].isAlive=true;
    gamestate[middle+width_box_count].isAlive=true;
    gamestate[(middle-width_box_count)+1].isAlive=true;
    gamestate[middle-1].isAlive=true;
    break;
  }
}
