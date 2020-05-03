class Cheese {
  PVector pos; 
  boolean grabbed; 
  Mouse mouse; 
  PImage cheeseImage; 

  Cheese(int x, int y) {
    pos = new PVector(x, y);
    cheeseImage = loadImage("cheese.png"); 
    cheeseImage.resize(cellSize,cellSize); 
  }

  void update() {
    fill(#E8D313);

    if (!grabbed) {
      image(cheeseImage, pos.x, pos.y);
    } else {
      cheeseImage.resize(cellSize/2,cellSize/2); 
      image(cheeseImage, mouse.pos.x, mouse.pos.y - cellSize/2);
    }
  }
}  