PFont font;
PImage menuImg, chooseImg, dogImg, catImg;
String state = "menu"; // can be "menu", "mode-select", "oneplayer", "twoplayer"

void setup() {
  size(1000, 600);
  font = createFont("Arial", 32, true);
  textFont(font);

  // Load all images at once
  menuImg = loadImage("menu.png");
  chooseImg = loadImage("choose.png");
  dogImg = loadImage("dog.png");
  catImg = loadImage("dogCat.png");
}

void draw() {
  background(0);

  if (state.equals("menu")) {
    image(menuImg, 0, 0, width, height);
    drawMenuButtons();
  } 
  else if (state.equals("mode-select")) {
    image(chooseImg, 0, 0, width, height);
    drawModeSelectUI();
  } 
  else if (state.equals("oneplayer")) {
    drawOnePlayerScreen();
  } 
  else if (state.equals("twoplayer")) {
    drawTwoPlayerScreen();
  }
}

void drawMenuButtons() {
  int buttonWidth = 150;
  int buttonHeight = 50;
  int centerY = 520;
  int spacing = 40;

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

void drawModeSelectUI() {
  int dogX = 300, dogY = 220, dogW = 130, dogH = 150;
  int catX = 500, catY = 210, catW = 200, catH = 160;

  boolean hover1P = mouseX >= dogX && mouseX <= dogX + dogW &&
                    mouseY >= dogY && mouseY <= dogY + dogH;
  boolean hover2P = mouseX >= catX && mouseX <= catX + catW &&
                    mouseY >= catY && mouseY <= catY + catH;

  if (hover1P) tint(245, 160, 159, 350);
  else noTint();
  image(dogImg, dogX, dogY, dogW, dogH);

  if (hover2P) tint(245, 160, 159, 350);
  else noTint();
  image(catImg, catX, catY, catW, catH);

  PFont boldFont = createFont("Arial Bold", 32, true);
  textFont(boldFont);
  textAlign(CENTER, CENTER);

  if (hover1P) fill(255, 100, 0);
  else fill(255, 255, 0);
  text("1 player", dogX + dogW / 2 + 2, dogY + dogH + 10 + 2);
  fill(0);
  text("1 player", dogX + dogW / 2, dogY + dogH + 10);

  if (hover2P) fill(255, 100, 0);
  else fill(255, 255, 0);
  text("2 player", catX + catW / 2 + 2, catY + catH + 10 + 2);
  fill(0);
  text("2 player", catX + catW / 2, catY + catH + 10);

  noTint();
}

void drawOnePlayerScreen() {
  background(200, 255, 200);
  textSize(36);
  textAlign(CENTER, CENTER);
  fill(0);
  text("🐶 One Player Game Screen", width / 2, height / 2);
}

void drawTwoPlayerScreen() {
  background(200, 200, 255);
  textSize(36);
  textAlign(CENTER, CENTER);
  fill(0);
  text("🐶🐱 Two Player Game Screen", width / 2, height / 2);
}

void mousePressed() {
  if (state.equals("menu")) {
    int buttonWidth = 150;
    int buttonHeight = 50;
    int centerY = 520;
    int spacing = 40;
    int startX = width / 2 - buttonWidth - spacing / 2;
    int exitX = width / 2 + spacing / 2;
    int y = centerY;

    if (mouseX >= startX && mouseX <= startX + buttonWidth &&
        mouseY >= y && mouseY <= y + buttonHeight) {
      state = "mode-select";
    }

    if (mouseX >= exitX && mouseX <= exitX + buttonWidth &&
        mouseY >= y && mouseY <= y + buttonHeight) {
      exit();
    }
  }

  if (state.equals("mode-select")) {
    int dogX = 300, dogY = 220, dogW = 130, dogH = 150;
    int catX = 500, catY = 210, catW = 200, catH = 160;

    if (mouseX >= dogX && mouseX <= dogX + dogW &&
        mouseY >= dogY && mouseY <= dogY + dogH) {
      state = "oneplayer";
    }

    if (mouseX >= catX && mouseX <= catX + catW &&
        mouseY >= catY && mouseY <= catY + catH) {
      state = "twoplayer";
    }
  }
}
