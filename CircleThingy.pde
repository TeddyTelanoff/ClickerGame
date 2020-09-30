class Circle {
  PVector position;
  PVector pmouse;
  float radius;
  color col;
  
  float stime;
  
  float time;
  float cscore;
  float scoreTime;
  String nscore;
  
  boolean shouldReset;
  
  Circle() {
    nscore = "";
    scoreTime = 100;
    pmouse = new PVector();
    position = new PVector();
    reset();
  }
  
  void reset() {
    shouldReset = false;
    radius = random(circleRadiusRange.x - streak / 4, circleRadiusRange.y - streak / 4) * scale;
    position = new PVector();
    position.x = random(radius, width - radius);
    position.y = random(radius, height - radius);
    
    col = int(random(0xFFFFFF)) | 0xFF000000;
  }
  
  void draw() {
    if (shouldReset)
      reset();
    
    fill(col);
    circle(position.x, position.y, radius * 2);
    
    time++;
  }
  
  void drawScore() {
    if (scoreTime <= globalScoreTime) {
      fill(255);
      textSize(max(radius / 3, 15));
      textAlign(CENTER, CENTER);
      text(nscore, pmouse.x, pmouse.y);
      
      scoreTime += 1 / frameRate;
    }
    
    if (stime <= globalStreakTime) {
      stime += 1 / frameRate;
    } else
      streak = 0;
  }
  
  void mousePressed() {
    cscore = max(radius / scale - max(time / frameRate, circleRadiusRange.x), minScore);
    pmouse = new PVector(mouseX, mouseY);
    
    if ((shouldReset = dist(mouseX, mouseY, position.x, position.y) <= radius + radiusPadding * scale) == true) {
      time = 0;
      
      stime = 0;
      streak++;
      highestStreak = max(highestStreak, streak);
      cscore *= streak;
      score += cscore;
      
      scoreTime = 0;
      nscore = "+" + cscore;
    } else {
      score -= cscore;
      
      stime = 0;
      scoreTime = 0;
      streak = 0;
      nscore = "-" + cscore;
    }
  }
}
