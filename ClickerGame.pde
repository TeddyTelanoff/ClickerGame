import static java.awt.event.KeyEvent.*;
import java.awt.Robot;

Circle[] circles;

static final String DATA_PATH = "data.json";
static final String HIGH_SCORE = "high-score";
static final String HIGH_STREAK = "high-streak";
static JSONObject data;

final PVector unscaledSize = new PVector(160, 90);
final float scale = 8;

final PVector circleRadiusRange = new PVector(10, 25);

final float minScore = 0.5;
final float globalScoreTime = 1.5;
final float globalStreakTime = 0.75;
final float globalShakeTime = 0.25;
final float shakeEffect = 7.5;

final float radiusPadding = 1;

float pointLostPerSecond = 5;

int streak;
int highestStreak;

float score;
float roundHighScore;
float highestScore;

boolean shake = true;

Robot r;
boolean robot = false;

void settings() {
  size(int(unscaledSize.x * scale), int(unscaledSize.y * scale));
  
  if (new File(dataPath(DATA_PATH)).exists()) {
    data = loadJSONObject(dataPath(DATA_PATH));
    
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
  
  circles = new Circle[] { new Circle() };
  
  try {
    r = new Robot();
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void draw() {
  surface.setTitle("Clicker Game | FPS: " + frameRate);
  background(57);
  
  for (Circle c : circles)
    if (c == null)
      c = new Circle();
  
  for (Circle c : circles)
    c.draw();
  for (Circle c : circles)
    c.drawScore();
  
  roundHighScore = max(score, roundHighScore);
  highestScore = max(highestScore, roundHighScore);
  score -= pointLostPerSecond / frameRate;
  pointLostPerSecond += (1 / frameRate);
  pointLostPerSecond = min(pointLostPerSecond, 1000);
  score = max(score, 0);
  
  fill(#696969);
  textSize(32);
  textAlign(LEFT, TOP);
  text("Score: " + int(score) + " | Round Highest: " + int(roundHighScore) + " | Highest: " + int(highestScore), 15, 15);
  textAlign(RIGHT, TOP);
  text("Streak: x" + int(streak) + " | Highest: x" + int(highestStreak), width - 15, 15);
  
  ppRun();
  
  if (robot)
    r.mouseMove(round(circles[0].position.x), round(circles[0].position.y));
}

void mousePressed() {
  for (Circle c : circles)
    c.mousePressed();
}

void keyReleased() {
  switch(keyCode) {
    case VK_F:
      //robot = !robot;
      break;
    case VK_S:
      shake = !shake;
      break;
    case VK_R:
      score = 0;
      pointLostPerSecond = 5;
      streak = 0;
      roundHighScore = 0;
      break;
  }
}
void exit() {
  data.setFloat(HIGH_SCORE, highestScore);
  data.setFloat(HIGH_STREAK, highestStreak);
  
  saveJSONObject(data, dataPath(DATA_PATH));
  
  super.exit();
}
