//Acknowledgments:
/*
  Rat Image - Zoeken from Pinterest https://www.pinterest.com/pin/294845106834889938/
  Cheese Image - Author Unknown - https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/87/8752089fa520c9a2c1691fa5abaa0b84c360081c_full.jpg 
  A* Algorithm - Utilized Adaptation of A* Algorithm created by Peter Hart, Nils Nilsson, and Betram Raphael from SRI International. 
*/

import java.util.HashSet;
import java.util.Collections; 

int hCells, cellSize, vCells; 
Node[][] maze;
Node current;
ArrayList<Node> frontier = new ArrayList<Node>();
boolean mazeGenComplete; 
PImage mouseUp1, mouseUp2, mouseDown1, mouseDown2, mouseLeft1, mouseLeft2, mouseRight1, mouseRight2; 
ArrayList<Cheese> cheeses; 
ArrayList<Mouse> mice; 
ArrayList<Mouse> deadMice; 

int numberOfCells = 50; 
int cellsDrawnPerFrame = 4; 
int movementSpeed = 7; 
int spawnTimer = 90; 
int maxMice = 10; 

void setup() {
  size(1125, 700);
  reset();
  mouseUp1 = loadImage("mouseUp1.png"); 
  mouseUp2 = loadImage("mouseUp2.png"); 
  mouseDown1 = loadImage("mouseDown1.png");
  mouseDown2  = loadImage("mouseDown2.png"); 
  mouseLeft1 = loadImage("mouseLeft1.png"); 
  mouseLeft2 = loadImage("mouseLeft2.png"); 
  mouseRight1 = loadImage("mouseRight1.png"); 
  mouseRight2 = loadImage("mouseRight2.png"); 
  mouseUp1.resize(cellSize, cellSize);
  mouseUp2.resize(cellSize, cellSize);
  mouseDown1.resize(cellSize, cellSize);
  mouseDown2.resize(cellSize, cellSize); 
  mouseLeft1.resize(cellSize, cellSize);
  mouseLeft2.resize(cellSize, cellSize); 
  mouseRight1.resize(cellSize, cellSize); 
  mouseRight2.resize(cellSize, cellSize); 
  strokeWeight(5);
}

void draw() {
  background(255); 
  if (!mazeGenComplete) constructMaze(); 
  for (Node[] row : maze) {
    for (Node curr : row) {
      if (curr.visited) curr.drawCell();
    }
  }
  if (mazeGenComplete) {
    if (frameCount % spawnTimer == 0 && mice.size() < maxMice) spawnMouse((int)random(cellSize, height - 100 - cellSize), (int)(random(cellSize, height - cellSize))); 
    deadMice = new ArrayList<Mouse>(); 
    for (Mouse m : mice) {
      if (m.pos.x > width + 100) deadMice.add(m); 
      m.update();
    }
    for (Mouse m : deadMice) mice.remove(m);
    for (Cheese c : cheeses) c.update();
  }
}

void keyPressed() {
  if (key == 'r') reset();
}
void mousePressed() {
  spawnMouse(mouseX, mouseY);
}
void spawnMouse(int x, int y) {
  if (mazeGenComplete) {
    int xCord = x / cellSize;
    int yCord = y / cellSize; 
    if (xCord < hCells && yCord < vCells) {
      Node curr = maze[yCord][xCord]; 
      Cheese created = new Cheese(curr.x, curr.y); 
      cheeses.add(created);
      Node startingPlace = maze[(int)random(vCells)][hCells-1]; 
      startingPlace.sides[3] = 0; 
      Mouse selected = new Mouse(startingPlace.x + cellSize/2, startingPlace.y + cellSize/2, created); 
      created.mouse = selected;
      mice.add(selected);
    }
  }
}

void reset() {
  hCells = width / numberOfCells; 
  cellSize = width / hCells; 
  vCells = height / cellSize; 
  hCells = (width-100) / numberOfCells; 
  maze = new Node[vCells][hCells]; 
  frontier = new ArrayList<Node>(); 
  cheeses = new ArrayList<Cheese>();
  mice = new ArrayList<Mouse>(); 
  for (int row = 0; row < maze.length; row++) {
    for (int col = 0; col < maze[row].length; col++) {
      maze[row][col] = new Node(col * cellSize, row * cellSize);
    }
  }
  current = maze[(int) random(vCells)][(int)random(hCells)]; 
  current.visited = true; 
  mazeGenComplete = false; 
  background(255);
}

void constructMaze() {
  for (int i = 0; i < cellsDrawnPerFrame; i++) {
    if (frontier.size() < (maze.length * maze[0].length)) {
      ArrayList<Node> goodNeighbors = current.unvisitedNeighbors(); 
      if (goodNeighbors.size() == 0) {
        if (frontier.size() > 0) {
          current = frontier.remove(frontier.size() -1);
        } else {
          mazeGenComplete = true; 
          continue;
        }
      } else {
        int choice = (int)(random(goodNeighbors.size()));  
        Node next = goodNeighbors.get(choice); 
        frontier.add(current); 
        current.sides[current.direction(next)] =0;
        next.sides[next.direction(current)] = 0; 
        current = next; 
        next.visited = true;
      }
    } else {
      mazeGenComplete = true;
    }
  }
}


ArrayList<Node> pathFinding (Node starting, Node ending) {
  HashSet<Node> closedSet = new HashSet<Node>(); 
  HashSet<Node> openSet = new HashSet<Node>(); 
  openSet.add(starting); 
  HashMap<Node, Node> cameFrom = new HashMap<Node, Node>(); 
  HashMap<Node, Integer> gScore = new HashMap<Node, Integer>(); 
  HashMap<Node, Integer> fScore = new HashMap<Node, Integer>(); 
  for (Node[] row : maze) {
    for (Node curr : row) {
      fScore.put(curr, Integer.MAX_VALUE);  
      gScore.put(curr, Integer.MAX_VALUE);
    }
  }
  gScore.replace(starting, 0); 
  //fScore.replace(starting, (abs(ending.iX - starting.iX) + abs(ending.iY - starting.iY)));  
  fScore.replace(starting, (int)(sqrt(pow((ending.iX-starting.iX), 2) + pow((ending.iY-starting.iY), 2)))); 
  while (openSet.size() > 0) {
    Node curr = null; 
    int lowestVal = Integer.MAX_VALUE;  
    for (Node n : openSet) {
      if (fScore.get(n) < lowestVal && !closedSet.contains(n)) {
        lowestVal = fScore.get(n); 
        curr = n;
      }
    }
    if (curr == ending) {
      return reconstructPath(cameFrom, curr);
    }
    openSet.remove(curr);
    closedSet.add(curr);
    for (Node n : curr.possibleNeighbors()) {
      if (closedSet.contains(n)) continue; 
      int tentativeGScore = gScore.get(curr) + (abs(curr.iX - n.iX) + abs(curr.iY-n.iY));
      if (!openSet.contains(n)) {
        openSet.add(n);
      } else if (tentativeGScore >= gScore.get(n)) {
        continue;
      }
      cameFrom.put(n, curr); 
      gScore.replace(n, tentativeGScore); 
      fScore.replace(n, gScore.get(n) + (abs(n.iX - ending.iX) + abs(n.iY - ending.iY)));
    }
  }
  return reconstructPath(cameFrom, ending);
}

ArrayList<Node> reconstructPath (HashMap<Node, Node> cameFrom, Node current) {
  ArrayList<Node> output = new ArrayList<Node>(); 
  output.add(current); 
  while (cameFrom.containsKey(current)) {
    current = cameFrom.get(current); 
    output.add(0, current);
  }
  return output;
}