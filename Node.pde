class Node {
  int x, y, iX, iY; 
  boolean noWall, visited;
  //where to draw the walls for each node
  int[] sides = new int[4]; 
  Node(int x, int y) {
    this.x = x;
    this.y = y; 
    iX = x / cellSize; 
    iY = y / cellSize; 
    for (int i = 0; i < sides.length; i++) sides[i] = 1;
  }

  void drawCell() {
    stroke(0); 
    if (sides[0] == 1) line(x, y, x + cellSize, y); 
    if (sides[1] == 1) line(x, y + cellSize, x + cellSize, y + cellSize); 
    if (sides[2] == 1) line(x, y, x, y + cellSize); 
    if (sides[3] == 1) line(x + cellSize, y, x + cellSize, y + cellSize);
  }

  int direction (Node neighbor) {
    if (x < neighbor.x) return 3; 
    else if (x > neighbor.x) return 2; 
    else if (y < neighbor.y) return 1; 
    else return 0;
  }
  ArrayList<Node> unvisitedNeighbors() {  
    ArrayList<Node> output = new ArrayList<Node>(); 
    if (iY - 1 >= 0  && !maze[iY-1][iX].visited) output.add(maze[iY-1][iX]); 
    if (iY + 1 < vCells && !maze[iY+1][iX].visited) output.add(maze[iY+1][iX]);
    if (iX - 1 >= 0 && !maze[iY][iX-1].visited) output.add(maze[iY][iX-1]); 
    if (iX + 1 < hCells && !maze[iY][iX + 1].visited) output.add(maze[iY][iX+1]);
    return output;
  }
  ArrayList<Node> possibleNeighbors() {
    ArrayList<Node> output = new ArrayList<Node>(); 
    if (iY - 1 >= 0  && sides[direction(maze[iY-1][iX])] == 0) output.add(maze[iY-1][iX]); 
    if (iY + 1 < vCells && sides[direction(maze[iY+1][iX])] == 0) output.add(maze[iY+1][iX]);
    if (iX - 1 >= 0 && sides[direction(maze[iY][iX-1])] == 0) output.add(maze[iY][iX-1]); 
    if (iX + 1 < hCells && sides[direction(maze[iY][iX+1])] == 0) output.add(maze[iY][iX+1]);
    return output;
  }
}