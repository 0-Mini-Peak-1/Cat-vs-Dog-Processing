public class ModeSelect extends PApplet {
  PFont font, boldFont;
  PImage modeSelectImg, dogImg, catImg;

  public void settings() {
    size(1000, 600);
  }

  public void setup() {
    font = createFont("Arial", 32, true);
    boldFont = createFont("Arial Bold", 32, true);
    textFont(font);
    modeSelectImg = loadImage("choose.png");
    println("Trying to load images...");
    dogImg = loadImage("dog.png");
    catImg = loadImage("dogCat.png");
    modeSelectImg = loadImage("choose.png");
  }

  public void draw() {
    image(modeSelectImg, 0, 0, width, height);
    drawModeSelectUI();
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
}
