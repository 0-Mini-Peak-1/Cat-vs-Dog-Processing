// OnePlayerGame.pde
public class OnePlayerGame extends PApplet {
  public void settings() {
    size(1000, 600);
  }

  public void setup() {
    background(200, 255, 200);
    textSize(36);
    textAlign(CENTER, CENTER);
  }

  public void draw() {
    background(200, 255, 200);
    text("🕹️ One Player Game Screen", width/2, height/2);
  }
}
