class Mouse {
  PVector pos; 
  Cheese target; 
  ArrayList<Node> path; 
  int currIndex; 
  boolean returning; 
  PVector targetPos; 
  PImage current; 
  boolean complete; 
  int dropoff; 
  boolean right; 

  Mouse(int x, int y, Cheese target) {
    pos = new PVector(x, y); 
    this.target = target; 
    path = pathFinding(maze[(int)(pos.y/cellSize)][(int)(pos.x/cellSize)], maze[(int)(target.pos.y/cellSize)][(int)(target.pos.x/cellSize)]);   
    currIndex = 1;
    Node next = path.get(currIndex+1); 
    targetPos = new PVector(next.x + cellSize/2, next.y + cellSize/2); 
    returning = false;
    current = mouseLeft1;
    dropoff = (int)random(width - 100, width - cellSize/4);
  }
  void update() {
    image(current, pos.x - cellSize/2, pos.y - cellSize/2); 
    if (frameCount % 5 == 0) right = !right; 
    if (!complete) { 
      for (int i = 0; i < movementSpeed; i++) {
        if (targetPos.x < pos.x) {
          pos.x--;
          if (right)current = mouseLeft1; 
          else current = mouseLeft2;
        } else if (targetPos.x > pos.x) {
          pos.x++;
          if (right) current = mouseRight1; 
          else current = mouseRight2;
        } else if (targetPos.y < pos.y) {
          pos.y--;
          if (right) current = mouseUp1; 
          else current = mouseUp2;
        } else if (targetPos.y > pos.y) {
          pos.y++;
          if (right) current = mouseDown1; 
          else current = mouseDown2;
        }
      }
      if (targetPos.x == pos.x && targetPos.y == pos.y) {
        if (pos.x - cellSize/2 == target.pos.x && pos.y - cellSize/2 == target.pos.y) {
          returning = true; 
          target.grabbed = true;
        }
        if (!returning)currIndex++;
        else currIndex--; 
        if (!(returning && pos.x - cellSize/2 == path.get(0).x && pos.y - cellSize/2 == path.get(0).y))
          targetPos = new PVector(path.get(currIndex).x + cellSize/2, path.get(currIndex).y + cellSize/2);
        else complete = true;
      }
    } else {
      if (right) current = mouseRight1; 
      else current = mouseRight2; 
      pos.x += movementSpeed;
      if (pos.x > dropoff && target.grabbed != false) {
        target.grabbed = false; 
        target.pos.x = pos.x;
        target.pos.y = pos.y; 
      }
    }
  }
}