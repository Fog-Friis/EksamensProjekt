class TextBox {

  //position and size
  PVector position, size;
  float scroll;

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
  boolean isProtected;
  String Text = "";
  String protectedText = "";
  int TextLength = 0;

  //if button is clicked
  boolean selected = false;

  //constructor
  TextBox(PVector position, PVector size, boolean isProtected, int visible) {
    this.position = position;
    this.size = size;
    this.isProtected = isProtected;
    this.visible = visible;
  }

  //display and run textbox
  void display() {

    pushMatrix();
    translate(0, scroll);

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

      if (isProtected) {
        text(protectedText, position.x + (textWidth("a") / 2), position.y + TEXTSIZE);
      } else {
        text(Text, position.x + (textWidth("a") / 2), position.y + TEXTSIZE);
      }
    } else {
      //sletter texten når man ikke er på menuen længere
      clearText();
    }
    translate(0, 0);
    popMatrix();
  }

  //check if key has been typed
  boolean keyWasTyped(char KEY, int KEYCODE) {

    if (visible == gamestate) {
      if (selected) {
        if (KEYCODE == (int)BACKSPACE) {
          backSpace();
        } else if (KEYCODE == 32) {
          if (isProtected) {
            addProtection('*');
          } else { 
            addText(' ');
          }
        } else if (KEYCODE == (int)ENTER) {
          return true;
        } else {
          // CHECK IF THE KEY IS A LETTER OR A NUMBER
          boolean isKeyCapitalLetter = (KEY >= 'A' && KEY <= 'Ø');
          boolean isKeySmallLetter = (KEY >= 'a' && KEY <= 'ø');
          boolean isKeyNumber = (KEY >= '0' && KEY <= '9');
          boolean isKeySign = (KEY >= 30 && KEY <= 200);


          if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber || isKeySign) {
            if (isProtected) {
              addProtection('*');
            }
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

  //add asterisk if textbox is a password textbox
  void addProtection(char text) {
    if (textWidth(Text + text) < (size.x)) {
      protectedText += text;
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
      if (y >= position.y + scroll && y <= position.y + size.y + scroll) {
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
