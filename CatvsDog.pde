import ddf.minim.*;

PImage menuImg, chooseImg, bgImg;
PImage dogImg, catImg;
PImage boneImg, canImg; // Images for projectiles
PImage[] icons = new PImage[8];
PFont font;
String state = "menu";
boolean catTurn = true;
float catHealth = 100;
float dogHealth = 100;
float wind = random(-1, 1);  // -1 to 1 range
Projectile currentProjectile;
boolean chargingPower = false;
float power = 0;
float maxPower = 25;
PImage[] catFrames = new PImage[3];
PImage[] dogFrames = new PImage[3];
int catFrameIndex = 0;
int dogFrameIndex = 0;
int frameDelay = 10;
int frameCount = 0;
boolean isAnimating = false;
Minim minim;
AudioPlayer menuMusic;
AudioPlayer inGameMusic;
AudioPlayer hitSound;


class Projectile {
  float x, y, vx, vy;
  boolean active;
  PImage img; // Image for the projectile

  Projectile(float startX, float startY, float angle, float power, PImage projectileImage) {
    x = startX;
    y = startY;
    vx = cos(radians(angle)) * power;
    vy = -sin(radians(angle)) * power;
    active = true;
    img = projectileImage; // Set the projectile image
  }

  void update() {
    if (!active) return;
    x += vx;
    y += vy;
    vy += 0.5; // gravity
    vx += wind * 0.1; // wind effect
    if (y > height) {
      active = false;
      nextTurn(); // missed shot
    }
    checkCollision();
  }

  void display() {
    if (active) {
      // Use fixed dimensions for projectiles
      int projectileWidth = 100; // Set width
      int projectileHeight = 100; // Set height

      // Draw the hitbox rectangle for testing
      fill(255, 0, 0);
      
      image(img, x, y, projectileWidth, projectileHeight); // Use fixed size here
    }
  }


  void checkCollision() {
    // Define the hitbox for the dog
    float dogWidth = 150; // Width of the dog image
    float dogHeight = 150; // Height of the dog image
    float dogCenterX = 810 + dogWidth / 2; // Center X of the dog image
    float dogCenterY = 420 + dogHeight / 2; // Center Y of the dog image
    float dogHitboxSize = 100; // Adjust as needed for better coverage

    // Define the hitbox for the cat
    float catWidth = 120; // Width of the cat image
    float catHeight = 110; // Height of the cat image
    float catCenterX = 22 + catWidth / 2; // Center X of the cat image
    float catCenterY = 363 + catHeight / 2; // Center Y of the cat image
    float catHitboxSize = 100; // Adjust as needed

    // Check collision with the dog (when it's the cat's turn)
    if (catTurn && dist(x, y, dogCenterX, dogCenterY) < dogHitboxSize) {
      dogHealth -= 20;
      active = false;
      hitSound.rewind(); // Rewind the sound to play from the start
      hitSound.play(); // Play the hit sound
      nextTurn();
    }
    // Check collision with the cat (when it's the dog's turn)
    else if (!catTurn && dist(x, y, catCenterX, catCenterY) < catHitboxSize) {
      catHealth -= 20;
      active = false;
      hitSound.rewind(); // Rewind the sound to play from the start
      hitSound.play(); // Play the hit sound
      nextTurn();
    }
}

}


void setup() {
  size(1000, 600);
  font = createFont("Arial", 32, true);
  textFont(font);

  menuImg = loadImage("menu.png");
  chooseImg = loadImage("choose.png");
  bgImg = loadImage("bg.png");
  dogImg = loadImage("dogstart.png");
  catImg = loadImage("catstart.png");

  // Load projectile images
  boneImg = loadImage("bone.png");
  canImg = loadImage("can.png");

  boneImg.resize(100, 100);
  canImg.resize(100, 100);

  icons[0] = loadImage("x2.png");
  icons[1] = loadImage("power.png");
  icons[2] = loadImage("bomb.png");
  icons[3] = loadImage("heal.png");
  icons[4] = loadImage("x2.png");
  icons[5] = loadImage("power.png");
  icons[6] = loadImage("bomb.png");
  icons[7] = loadImage("heal.png");

  catFrames[0] = loadImage("catframe1.png");
  catFrames[1] = loadImage("catframe2.png");
  catFrames[2] = loadImage("catframe3.png");

  dogFrames[0] = loadImage("dogframe1.png");
  dogFrames[1] = loadImage("dogframe2.png");
  dogFrames[2] = loadImage("dogframe3.png");

  minim = new Minim(this);
  menuMusic = minim.loadFile("menuMusic.mp3");  // Load menu music
  inGameMusic = minim.loadFile("inGameMusic.mp3");  // Load in-game music
  hitSound = minim.loadFile("hit.mp3"); // Load the hit sound effect

  // Set lower volume
  menuMusic.setGain(-12);
  inGameMusic.setGain(-12);
  hitSound.setGain(-12);
}

void draw() {
  background(0);

  if (state.equals("menu")) {
    if (!menuMusic.isPlaying()) {
      menuMusic.loop(); // Loop the menu music
    }
    if (inGameMusic.isPlaying()) {
      inGameMusic.pause(); // Stop in-game music if it's playing
    }
    image(menuImg, 0, 0, width, height);
    drawMenuButtons();
  } else if (state.equals("mode-select")) {
    if (!menuMusic.isPlaying()) {
      menuMusic.loop(); // Loop the menu music
    }
    if (inGameMusic.isPlaying()) {
      inGameMusic.pause(); // Stop in-game music if it's playing
    }
    image(chooseImg, 0, 0, width, height);
    drawModeSelectUI();
  } else if (state.equals("twoplayer")) {
    if (menuMusic.isPlaying()) {
      menuMusic.pause(); // Stop menu music
    }
    if (!inGameMusic.isPlaying()) {
      inGameMusic.loop(); // Loop the in-game music
    }
    drawTwoPlayerScreen();
  } else if (state.equals("oneplayer")) {
    if (menuMusic.isPlaying()) {
      menuMusic.pause(); // Stop menu music
    }
    if (!inGameMusic.isPlaying()) {
      inGameMusic.loop(); // Loop the in-game music
    }
    drawOnePlayerScreen();
  }
}

void pause() {
  // Stop music before exiting
  if (menuMusic.isPlaying()) {
    menuMusic.close();
  }
  if (inGameMusic.isPlaying()) {
    inGameMusic.close();
  }
  if (hitSound.isPlaying()) {
    hitSound.close(); // Close hit sound if it’s playing
  }
  minim.stop(); // Stop the Minim instance
  super.stop(); // Call the parent class's stop method
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
  // Show background
  image(bgImg, 0, 0, width, height);
  float catHitboxWidth = 100;
  float catHitboxHeight = 100;
  float dogHitboxWidth = 110;
  float dogHitboxHeight = 110;

  // Determine which character is throwing
    if (catTurn) {
        if (isAnimating) {
            frameCount++;
            if (frameCount % frameDelay == 0) {
                catFrameIndex = (catFrameIndex + 1) % catFrames.length; // Cycle through frames
            }
            image(catFrames[catFrameIndex], 22, 363, 120, 110); // Draw animated cat
        } else {
            image(catImg, 22, 363, 120, 110); // Static frame for the cat
        }
        
        image(dogImg, 810, 420, 150, 150); // Static dog image
    } else {
        if (isAnimating) {
            frameCount++;
            if (frameCount % frameDelay == 0) {
                dogFrameIndex = (dogFrameIndex + 1) % dogFrames.length; // Cycle through frames
            }
            image(dogFrames[dogFrameIndex], 810, 420, 150, 150); // Draw animated dog
        } else {
            image(dogImg, 810, 420, 150, 150); // Static frame for the dog
        }

        image(catImg, 22, 363, 120, 110); // Static cat image
    }


  // Health bars and other UI elements remain unchanged
  textAlign(LEFT, CENTER);
  textSize(20);

  // Cat's health bar
  fill(0);
  rect(145, 39, 310, 22);  // background frame
  fill(255, 0, 0);
  rect(150, 40, catHealth * 3, 20);
  fill(255);
  text("Cat HP: " + int(catHealth), 150, 20);

  // Dog's health bar
  fill(0);
  rect(545, 39, 310, 22);  // background frame
  fill(255, 0, 0);
  rect(550, 40, dogHealth * 3, 20);
  fill(255);
  text("Dog HP: " + int(dogHealth), 740, 20);

  // Display wind bar dynamically based on wind value
  float windBarLength = map(wind, -1, 1, 0, 200); // Map wind to bar length
  float windBarX = width / 2 - 100; // Center the bar
  float windBarY = 80; // Position in the top center

  // Draw wind bar background
  fill(0); // Background for visual clarity
  rect(windBarX, windBarY, 200, 20); // Background frame

  // Draw the actual wind bar based on wind strength
  fill(255, 255, 0); // Yellow color
  rect(windBarX + 2, windBarY + 2, windBarLength, 16); // Bar representation

  // Display wind direction (arrow or value if needed)
  fill(0);
  textAlign(CENTER, CENTER);
  text("WIND: " + nf(wind, 1, 2), width / 2, windBarY + 40);

  // Handle game over situation
  if (catHealth <= 0 || dogHealth <= 0) {
    fill(0, 200);
    rect(0, 0, width, height);
    fill(255);
    textSize(48);
    textAlign(CENTER, CENTER);
    if (catHealth <= 0) {
      text("🐶 Dog Wins!", width / 2, height / 2);
    } else {
      text("🐱 Cat Wins!", width / 2, height / 2);
    }
    noLoop(); // Stop the game
  }

  // Display projectile
  if (currentProjectile != null) {
    currentProjectile.update();
    currentProjectile.display();
  }

  // Display icons
  for (int i = 0; i < 4; i++) {
    image(icons[i], 30 + i * 90, 80, 80, 80);
  }
  for (int i = 4; i < 8; i++) {
    image(icons[i], 1040 - (8 - i) * 90 - 50, 80, 80, 80);
  }

  // Power gauge above current character
  float px, py;
  if (catTurn) {
    px = 22 + 60; // cat position center
    py = 363 - 20;
  } else {
    px = 810 + 75;
    py = 420 - 20;
  }
  fill(0);
  rect(px - 30, py - 10, 60, 10); // background
  fill(0, 255, 0);
  rect(px - 30, py - 10, map(power, 0, maxPower, 0, 60), 10); // current power

  if (chargingPower) {
    power += 0.3;
    if (power > maxPower) power = maxPower;
  }

  // Reset isAnimating when the turn ends
  if (currentProjectile == null) { // Assuming a projectile's null state indicates the turn is over
    isAnimating = false; // Reset the animation state for the next turn
  }
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

  // Restart on click if game over
  if ((catHealth <= 0 || dogHealth <= 0) && state.equals("twoplayer")) {
    catHealth = 100;
    dogHealth = 100;
    catTurn = true;
    wind = random(-1, 1);
    loop(); // Resume game
    return;
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

void keyPressed() {
  if (state.equals("twoplayer") && key == ' ') {
    chargingPower = true;
  }
}

void keyReleased() {
  if (state.equals("twoplayer") && key == ' ' && chargingPower) {
    chargingPower = false;
    float angle = random(30, 60);

    // Use the corresponding image based on whose turn it is
    PImage projectileImage = catTurn ? canImg : boneImg;

    if (catTurn) {
      currentProjectile = new Projectile(22 + 60, 363, angle, power, projectileImage);
    } else {
      currentProjectile = new Projectile(810 + 75, 420, 180 - angle, power, projectileImage);
    }

    power = 0; // reset after launch
    isAnimating = true; // Start animation
  }
}

void nextTurn() {
  catTurn = !catTurn;
  wind = random(-1, 1);

  // Reset animation state for the next turn
  isAnimating = false;
}
