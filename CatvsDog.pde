PImage menuImg, chooseImg, bgImg;
PImage dogImg, catImg;
PImage[] icons = new PImage[8];
PFont font;
String state = "menu";

void setup() {
  size(1000, 600);
  font = createFont("Arial", 32, true);
  textFont(font);

  menuImg = loadImage("menu.png");
  chooseImg = loadImage("choose.png");
  bgImg = loadImage("bg.png");
  dogImg = loadImage("dogstart.png");
  catImg = loadImage("catstart.png");

  icons[0] = loadImage("x2.png");
  icons[1] = loadImage("power.png");
  icons[2] = loadImage("bomb.png");
  icons[3] = loadImage("heal.png");
  icons[4] = loadImage("x2.png");
  icons[5] = loadImage("power.png");
  icons[6] = loadImage("bomb.png");
  icons[7] = loadImage("heal.png");
}

void draw() {
  background(0);
  if (state.equals("menu")) {
    image(menuImg, 0, 0, width, height);
    drawMenuButtons();
  } else if (state.equals("mode-select")) {
    image(chooseImg, 0, 0, width, height);
    drawModeSelectUI();
  } else if (state.equals("twoplayer")) {
    drawTwoPlayerScreen();
  } else if (state.equals("oneplayer")) {
    drawOnePlayerScreen();
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
  image(loadImage("dog.png"), dogX, dogY, dogW, dogH);

  if (hover2P) tint(245, 160, 159, 350);
  else noTint();
  image(loadImage("dogCat.png"), catX, catY, catW, catH);

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

void drawTwoPlayerScreen() {
  image(bgImg, 0, 0, width, height);
  image(catImg, 22, 363, 120, 110);
  image(dogImg, 810, 420, 150, 150);


  fill(255, 0, 0);
  rect(150, 40, 300, 20);
  rect(550, 40, 300, 20);

  fill(255, 255, 0);
  rect(390, 40, 220, 20);

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("WIND", width / 2, 30);

  for (int i = 0; i < 4; i++) {
    image(icons[i], 50 + i * 60, 80, 50, 50);
  }
  for (int i = 4; i < 8; i++) {
    image(icons[i], 1000 - (8 - i) * 60 - 50, 80, 50, 50);
  }
 //fill(0);
//textSize(20);
//textAlign(CENTER, CENTER);
//text("mouseX: " + mouseX + "   mouseY: " + mouseY, width / 2, 40);
}

void drawOnePlayerScreen() {
  background(200, 255, 200);
  textSize(36);
  textAlign(CENTER, CENTER);
  fill(0);
  text("🐶 One Player Game Screen", width / 2, height / 2);
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
