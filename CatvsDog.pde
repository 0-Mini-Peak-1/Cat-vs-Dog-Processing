import ddf.minim.*;

PImage menuImg, chooseImg, bgImg;
PImage dogImg, catImg;
PImage boneImg, canImg; // Images for projectiles
PImage[] icons = new PImage[8];
PFont font;
String state = "twoplayer";
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
boolean[] catAbilities = {true, true, true, true};
boolean[] dogAbilities = {true, true, true, true};
int catDamageMultiplier = 1;
int dogDamageMultiplier = 1;
int catThrowCount = 0;
int dogThrowCount = 0;
boolean showTutorial = true;
int tutorialStartTime = 0;
int tutorialDuration = 7500; // 7.5 seconds
boolean showGameOver = false;
String winnerText = "";

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
      int projectileHeight = 50; // Set height

      // Draw the hitbox rectangle for testing
      fill(255, 0, 0);

      image(img, x, y, projectileWidth, projectileHeight); // Use fixed size here
    }
  }


  void checkCollision() {
    // Define the hitbox for the dog
    float dogCenterX = 810 + 75; // X position of the dog
    float dogCenterY = 420 + 75; // Y position of the dog
    float dogHitboxSize = 100; // Radius for the dog detection

    // Define the hitbox for the cat
    float catCenterX = 22 + 60; // X position of the cat
    float catCenterY = 363 + 55; // Y position of the cat
    float catHitboxSize = 100; // Radius for the cat detection

    // Check collision with the dog (when it's the cat's turn)
    if (catTurn && dist(x, y, dogCenterX, dogCenterY) < dogHitboxSize) {
      dogHealth -= 20 * catDamageMultiplier; // Calculate damage with multiplier
      active = false;
      hitSound.rewind();
      hitSound.play();
      nextTurn();
    }
    // Check collision with the cat (when it's the dog's turn)
    else if (!catTurn && dist(x, y, catCenterX, catCenterY) < catHitboxSize) {
      catHealth -= 20 * dogDamageMultiplier; // Calculate damage with multiplier
      active = false;
      hitSound.rewind();
      hitSound.play();
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

  icons[0] = loadImage("power.png");
  icons[1] = loadImage("heal.png");
  icons[2] = loadImage("bomb.png");
  icons[3] = loadImage("heal.png");
  icons[4] = loadImage("power.png");
  icons[5] = loadImage("heal.png");
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
  if (showTutorial) {
    int elapsed = millis() - tutorialStartTime;
    if (elapsed > tutorialDuration) {
      showTutorial = false;
    } else {
      // Draw semi-transparent black background
      fill(0, 150); // Black with alpha
      noStroke();
      rect(0, 0, width, height);

      // Tutorial text
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(24);
      text("Welcome to Cat vs Dog.\nUse spacebar to charge and release to throw.\nEach player takes turns.\nFirst to deplete opponent's health wins!", width / 2, height / 2);
    }
  }
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
  showGameOver = true;
  winnerText = (catHealth <= 0) ? "🐶 Dog Wins!" : "🐱 Cat Wins!";
  noLoop();
}

if (showGameOver) {
  fill(0, 200);
  rect(0, 0, width, height);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(48);
  text(winnerText, width / 2, height / 2 - 100);

  // Restart button
  fill(100, 200, 100);
  rect(width / 2 - 100, height / 2, 200, 50);
  fill(0);
  textSize(24);
  text("Restart", width / 2, height / 2 + 25);

  // Main Menu button
  fill(200, 100, 100);
  rect(width / 2 - 100, height / 2 + 70, 200, 50);
  fill(0);
  text("Main Menu", width / 2, height / 2 + 95);
}

  // Display projectile
  if (currentProjectile != null) {
    currentProjectile.update();
    currentProjectile.display();
  }

  // Define positions for ability icons
  int iconWidth = 60;
  int iconHeight = 60;

  // Draw ability icons for the cat (only Double Damage and Heal)
  for (int i = 0; i < 2; i++) { // Change to 2 to reflect only two abilities now
    if (catAbilities[i]) { // Only draw if the ability is active
      image(icons[i], 40 + i * 80, 70, 60, 60); // Draw the ability icon
    }
  }

  // Draw ability icons for the dog (only Double Damage and Heal)
  for (int i = 0; i < 2; i++) { // Change to 2
    if (dogAbilities[i]) { // Only draw if the ability is active
      image(icons[i + 4], width - 120 - i * 80, 70, 60, 60); // Draw the ability icon
    }
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

void resetGameState() {
  catHealth = 100;
  dogHealth = 100;
  catTurn = true;
  power = 0;
  chargingPower = false;
  isAnimating = false;
  currentProjectile = null;
  frameCount = 0;
  catFrameIndex = 0;
  dogFrameIndex = 0;
  showGameOver = false;
  winnerText = "";

  for (int i = 0; i < catAbilities.length; i++) catAbilities[i] = true;
  for (int i = 0; i < dogAbilities.length; i++) dogAbilities[i] = true;
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
      resetGameState();
      state = "mode-select";
      loop();
    }

    if (mouseX >= exitX && mouseX <= exitX + buttonWidth &&
      mouseY >= y && mouseY <= y + buttonHeight) {
      exit();
    }
  }

  if (showGameOver) {
    // Restart button
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
        mouseY > height / 2 && mouseY < height / 2 + 50) {
      restartGame();
    }
    // Main Menu button
    else if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
             mouseY > height / 2 + 70 && mouseY < height / 2 + 120) {
      state = "menu";
      resetGameState();
      loop(); // Resume draw loop if paused
    }
  }

  if (state.equals("twoplayer")) {

    // Check if it's the cat's turn and handle cat abilities
    if (catTurn) {
      for (int i = 0; i < 4; i++) {
        if (mouseX >= 40 + i * 80 && mouseX <= 40 + i * 80 + 60 &&
          mouseY >= 70 && mouseY <= 70 + 60) {
          activateCatAbility(i); // Activate the ability for the cat
        }
      }
    } else { // If it's the dog's turn, check dog's abilities
      for (int i = 0; i < 4; i++) {
        if (mouseX >= width - 120 - i * 80 && mouseX <= width - 120 - i * 80 + 60 &&
          mouseY >= 70 && mouseY <= 70 + 60) {
          activateDogAbility(i); // Activate the ability for the dog
        }
      }
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
      tutorialStartTime = millis();
      showTutorial = true;
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

  // Reset ability states
  isAnimating = false;
  catDamageMultiplier = 1; // Reset multiplier for cat
  dogDamageMultiplier = 1; // Reset multiplier for dog
}

void restartGame() {
  catHealth = 100;
  dogHealth = 100;
  catTurn = true;
  power = 0;
  chargingPower = false;
  isAnimating = false;
  currentProjectile = null;
  frameCount = 0;
  catFrameIndex = 0;
  dogFrameIndex = 0;
  showGameOver = false;

  // Reset abilities if necessary
  for (int i = 0; i < catAbilities.length; i++) catAbilities[i] = true;
  for (int i = 0; i < dogAbilities.length; i++) dogAbilities[i] = true;

  loop(); // Resume draw loop
}

void activateCatAbility(int abilityIndex) {
  if (catAbilities[abilityIndex]) {
    switch (abilityIndex) {
    case 0: // Double Damage
      catDamageMultiplier = 2; // Double the damage for next hit
      catAbilities[abilityIndex] = false; // Disable this ability
      break;
    case 1: // Heal
      catHealth = 100; // Heal the cat back to full health
      catAbilities[abilityIndex] = false; // Disable this ability
      nextTurn(); //Skip turn
      break;
    }
  }
}

void activateDogAbility(int abilityIndex) {
  if (dogAbilities[abilityIndex]) {
    switch (abilityIndex) {
    case 0: // Double Damage
      dogDamageMultiplier = 2; // Double the damage for next hit
      dogAbilities[abilityIndex] = false; // Disable this ability
      break;
    case 1: // Heal
      dogHealth = 100; // Heal the dog back to full health
      dogAbilities[abilityIndex] = false; // Disable this ability
      nextTurn(); //Skip turn
      break;
    }
  }
}
