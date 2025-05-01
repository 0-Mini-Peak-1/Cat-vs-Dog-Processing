// TwoPlayerGame.pde
public class TwoPlayerGame extends PApplet {
  public void settings() {
    size(1000, 600);
  }

  public void setup() {
    background(200, 200, 255);
    textSize(36);
    textAlign(CENTER, CENTER);
  }

  public void draw() {
    background(200, 200, 255);
    text("🎮 Two Player Game Screen", width/2, height/2);
  }
}
