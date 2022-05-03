class Button {

  PVector pos;
  PVector size;

  color col, overCol, pressedCol;

  float radius;

  PVector box1size, box1pos, box2size, box2pos;
  PVector circle1pos, circle2pos, circle3pos, circle4pos;

  boolean clicked = false;

  String Text;
  float textSize;
  
  int visible;

  Button(PVector p, PVector s, float r, color col, color ocol, color pcol, String Text, float textSize, int v) {

    this.pos = p;
    this.size = s;
    this.radius = r;
    this.col = col;
    this.overCol = ocol;
    this.pressedCol = pcol;
    this.Text = Text;
    this.textSize = textSize;
    this.visible = v;


    box1pos = new PVector(pos.x, pos.y-radius/2);
    box2pos = new PVector(pos.x-radius/2, pos.y);

    box1size = new PVector(size.x, size.y+radius);
    box2size = new PVector(size.x+radius, size.y);

    circle1pos = new PVector(pos.x, pos.y);
    circle2pos = new PVector(pos.x+size.x, pos.y);
    circle3pos = new PVector(pos.x+size.x, pos.y+size.y);
    circle4pos = new PVector(pos.x, pos.y+size.y);
  }

  boolean over() {
    if ((mouseX <= box1pos.x+box1size.x && mouseX >= box1pos.x && mouseY <= box1pos.y+box1size.y && mouseY >= box1pos.y) ||
      (mouseX <= box2pos.x+box2size.x && mouseX >= box2pos.x && mouseY <= box2pos.y+box2size.y && mouseY >= box2pos.y) ||
      (dist(mouseX, mouseY, circle1pos.x, circle1pos.y)<radius/2) ||
      (dist(mouseX, mouseY, circle2pos.x, circle2pos.y)<radius/2) ||
      (dist(mouseX, mouseY, circle3pos.x, circle3pos.y)<radius/2) ||
      (dist(mouseX, mouseY, circle4pos.x, circle4pos.y)<radius/2)) {
      return true;
    } else {
      return false;
    }
  }

  void pressed() {
    if (over()) {
      clicked = true;
    }
  }

  void released() {
    clicked = false;
  }

  void display() {

    noStroke();

    if (clicked) {
      fill(pressedCol);
      clicked=false;
    } else if (over()) {
      fill(overCol);
    } else {
      fill(col);
    }

    rect(box1pos.x, box1pos.y, box1size.x, box1size.y);
    rect(box2pos.x, box2pos.y, box2size.x, box2size.y);

    circle(circle1pos.x, circle1pos.y, radius);
    circle(circle2pos.x, circle2pos.y, radius);
    circle(circle3pos.x, circle3pos.y, radius);
    circle(circle4pos.x, circle4pos.y, radius);

    textAlign(CENTER);
    fill(0, 0, 0);
    textSize(textSize);
    text(Text, pos.x+size.x/2, pos.y+textSize*2/3+size.y*1/3);
    textAlign(CORNER);
  }
  
  void run(){
    if(visible == gamestate){
      display();
    }
  }
}
