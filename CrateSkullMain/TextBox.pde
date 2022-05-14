class TextBox {

  //position and size
  PVector position, size;

  //visibility
  int visible;

  //colors
  color Background = color(140, 140, 140);
  color Foreground = color(0, 0, 0);
  color BackgroundSelected = color(160, 160, 160);
  color Border = color(30, 30, 30);

  //border
  boolean BorderEnable = false;
  int BorderWeight = 1;

  //text and textsize
  int TEXTSIZE = 48;
  String Text = "";
  int TextLength = 0;

  //if button is clicked
  boolean selected = false;

  //constructor
  TextBox(PVector position, PVector size, int visible) {
    this.position = position;
    this.size = size;
    this.visible = visible;
  }

  //display and run textbox
  void display() {

    pushMatrix();

    if (visible == gamestate) {
      // DRAWING THE BACKGROUND
      if (selected) {
        fill(BackgroundSelected);
      } else {
        fill(Background);
      }

      if (BorderEnable) {
        strokeWeight(BorderWeight);
        stroke(Border);
      } else {
        noStroke();
      }

      rectMode(CORNER);

      rect(position.x, position.y, size.x, size.y);

      // DRAWING THE TEXT ITSELF
      fill(Foreground);
      textSize(TEXTSIZE);
      textAlign(CORNER);

        text(Text, position.x + (textWidth("a") / 2), position.y + TEXTSIZE);
    } else {
      //sletter texten når man ikke er på menuen længere
      clearText();
    }
    popMatrix();
  }

  //check if key has been typed
  boolean keyWasTyped(char KEY, int KEYCODE) {

    if (visible == gamestate) {
      if (selected) {
        if (KEYCODE == (int)BACKSPACE) {
          backSpace();
        } else if (KEYCODE == 32) {
            addText(' ');
        } else if (KEYCODE == (int)ENTER) {
          return true;
        } else {
          // CHECK IF THE KEY IS A LETTER OR A NUMBER
          boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Ø');
          boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'ø');
          boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
          boolean isKeySign = (KEY >= 30 && KEY <= 200);


          if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber || isKeySign) {
            addText(KEY);
          }
        }
      }
    }
    return false;
  }

  //add text to textbox
  void addText(char text) {
    if (textWidth(Text + text) < (size.x)) {
      Text += text;
      TextLength++;
    }
  }

  //remove text if backspace is pressed
  void backSpace() {
    if (TextLength - 1 >= 0) {
      Text = Text.substring(0, TextLength - 1);
      TextLength--;
    }
  }

  //check if mouse is over box
  boolean overBox(int x, int y) {
    if (x >= position.x && x <= position.x + size.x) {
      if (y >= position.y && y <= position.y + size.y ) {
        return true;
      }
    }

    return false;
  }

  //check if mouse has been pressed
  void pressed(int x, int y) {
    if (overBox(x, y)) {
      selected = true;
    } else {
      selected = false;
    }
  }

  //remove all text
  void clearText() {
    TextLength = 0;
    Text = "";
  }
}
