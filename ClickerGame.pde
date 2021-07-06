import static java.awt.event.KeyEvent.*;

Circle circle;

static final String DATA_PATH = "data.json";
static final String HIGH_SCORE = "high-score";
static final String HIGH_STREAK = "high-streak";
static JSONObject data;

final PVector unscaledSize = new PVector(160, 90);
final float scale = 10;

final PVector circleRadiusRange = new PVector(10, 25);

final float minScore = 0.5;
final float globalScoreTime = 1.5;
final float globalStreakTime = 0.75;
final float streakTimeMul = 0.98;
final float globalShakeTime = 0.25;
final float shakeEffect = 7.5;

final float radiusPadding = 1;

final float initialPointLostPerSecond = 5;
final float initialTime = 25;

final float scoreTimeMult = 1;

float pointLostPerSecond = initialPointLostPerSecond;

int streak;
int highestStreak;

float pframe, now, deltaTime;
float time = initialTime;
float streakTime = globalStreakTime;

float score;
float highestScore;

boolean shake = true, godMode, didGodMode;

boolean lossed, pp = true;

void settings() {
  //size(int(unscaledSize.x * scale), int(unscaledSize.y * scale));
  fullScreen();
  
  if (new File(sketchPath(DATA_PATH)).exists()) {
    data = loadJSONObject(sketchPath(DATA_PATH));
    
    highestScore = data.getFloat(HIGH_SCORE);
    highestStreak = data.getInt(HIGH_STREAK);
  }
  else {
    data = new JSONObject();
    data.setFloat(HIGH_SCORE, 0);
    data.setInt(HIGH_STREAK, 0);
  }
}

void setup() {
  frameRate(Float.MAX_VALUE);
  noStroke();
  
  circle = new Circle();
  pframe = millis();
}

void draw() {
  //surface.setTitle("Clicker Game | FPS: " + frameRate);
  background(64);
  
  now = millis();
  deltaTime = (now - pframe) / 1000;
  pframe = now;
  
  if (time <= 0) {
    background(0);
    return;
  } else
    time -= deltaTime * initialPointLostPerSecond;
  
  if (circle == null)
     circle = new Circle();
  
  circle.draw();
  circle.drawScore();
  
  highestScore = max(highestScore, score);
  //score -= pointLostPerSecond / frameRate;
  //pointLostPerSecond += (1 / frameRate);
  //pointLostPerSecond = min(pointLostPerSecond, 1000);
  //score = max(score, 0);
  
  if (godMode)
    circle.hit();
  
  fill(#696969);
  textSize(36);
  textAlign(LEFT, TOP);
  text("Score: " + int(score) + " | Highest: " + int(highestScore), 15, 15);
  textAlign(RIGHT, TOP);
  text("Streak: x" + int(streak) + " | Highest: x" + int(highestStreak), width - 15, 15);
  textAlign(LEFT, BOTTOM);
  text("Time: " + int(time), 15, height - 15);
  
  if (pp)
    ppRun();
  
  if (godMode) {
    fill(0, 255, 0);
    square(0, 0, 5);
  }
}

void mousePressed() {
  if (time <= 0) {
    reset();
    return;
  }
  
  circle.mousePressed();
}

void reset() {
  didGodMode = godMode;
  pframe = millis();
  time = initialTime;
  score = 0;
  pointLostPerSecond = initialPointLostPerSecond;
  streak = 0;
}

void keyReleased() {
  switch(keyCode) {
    case VK_P:
      pp = !pp;
      break;
    case VK_G:
      didGodMode = true;
      godMode = !godMode;
      break;
    case VK_S:
      shake = !shake;
      break;
    case VK_R:
      reset();
      break;
  }
}
void exit() {
  if (didGodMode) {
    super.exit();
    return;
  }
  
  data.setFloat(HIGH_SCORE, highestScore);
  data.setFloat(HIGH_STREAK, highestStreak);
  
  saveJSONObject(data, sketchPath(DATA_PATH));
  
  super.exit();
}
