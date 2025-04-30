PFont font;
PImage menuImg;
int buttonWidth = 150;
int buttonHeight = 50;
int centerY = 520;
int spacing = 40;

void setup() {
  size(1000, 600);
  font = createFont("Arial", 32, true);
  textFont(font);
  menuImg = loadImage("menu.png");
}

void draw() {
  image(menuImg, 0, 0, width, height);
  drawButtons();
}

void drawButtons() {
  fill(255, 230, 0);
  stroke(0);
  rect(width / 2 - buttonWidth - spacing / 2, centerY, buttonWidth, buttonHeight, 10);
  fill(255, 0, 0);
  textSize(28);
  textAlign(CENTER, CENTER);
  text("start", width / 2 - buttonWidth - spacing / 2 + buttonWidth / 2, centerY + buttonHeight / 2);

  fill(255, 230, 0);
  stroke(0);
  rect(width / 2 + spacing / 2, centerY, buttonWidth, buttonHeight, 10);
  fill(255, 0, 0);
  text("exit", width / 2 + spacing / 2 + buttonWidth / 2, centerY + buttonHeight / 2);
}

void mousePressed() {
  int startX = width / 2 - buttonWidth - spacing / 2;
  int exitX = width / 2 + spacing / 2;
  int y = centerY;

  if (mouseX >= startX && mouseX <= startX + buttonWidth &&
      mouseY >= y && mouseY <= y + buttonHeight) {
    // Start -> open mode selection file
    surface.setVisible(false);
    runSketch(new String[] { "ModeSelect" }, new ModeSelect()); // launch next
  }

  if (mouseX >= exitX && mouseX <= exitX + buttonWidth &&
      mouseY >= y && mouseY <= y + buttonHeight) {
    exit();
  }
}
