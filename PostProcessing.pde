color[] ppPixels;

void ppScreenShake(int x, int y, PVector dir) {
  pixels[ppGetPixelIndex(x, y)] = ppPixels[ppGetPixelIndex(int(x + dir.x), int(y + dir.y))];
}

void ppVignette(int x, int y, float softness, float radius) {
    PVector uv = new PVector(float(x) / pixelWidth, float(y) / pixelHeight);
    uv.x *= 1 - uv.x;
    uv.y *= 1 - uv.y;
    float vignette = uv.x * uv.y * softness;
    vignette = pow(vignette, radius);
    
    pixels[ppGetPixelIndex(x, y)] = color((255 - red(pixels[ppGetPixelIndex(x, y)])) - (255 - vignette * 255), (255 - green(pixels[ppGetPixelIndex(x, y)])) - (255 - vignette * 255), (255 - blue(pixels[ppGetPixelIndex(x, y)])) - (255 - vignette * 255));
}

void ppExposure(int x, int y, float min, float max) {
  color underExposed = ppMultColor(pixels[ppGetPixelIndex(x, y)], color(min));
  color overExposed = ppMultColor(pixels[ppGetPixelIndex(x, y)], color(max));
  
  pixels[ppGetPixelIndex(x, y)] = ppLerpColor(underExposed, overExposed, pixels[ppGetPixelIndex(x, y)]);
}

void ppBloom(int x, int y, color brightnessThreshold) {
  float brightness = PVector.dot(new PVector(red(pixels[ppGetPixelIndex(x, y)]) / 255, blue(pixels[ppGetPixelIndex(x, y)]) / 255, green(pixels[ppGetPixelIndex(x, y)]) / 255), new PVector(red(brightnessThreshold) / 255, blue(brightnessThreshold) / 255, green(brightnessThreshold) / 255));
  
  if (brightness > 1) {
    float[] weights = { 0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216 };
    for (int i = 0; i < weights.length; i++) {
      pixels[ppGetPixelIndex(int(x * weights[i]), int(y * weights[i]))] = ppAddColor(pixels[ppGetPixelIndex(int(x * weights[i]), int(y * weights[i]))], ppPixels[ppGetPixelIndex(x, y)]);
    }
  }
}

void ppBlur(int x, int y, PVector direction) {
  PVector off1 = PVector.mult(direction, 1.411764705882353);
  PVector off2 = PVector.mult(direction, 3.2941176470588234);
  PVector off3 = PVector.mult(direction, 5.176470588235294);
  color col = ppMultColor(ppPixels[ppGetPixelIndex(x, y)], color(0.1964825501511404 * 255));
  col = ppAddColor(col, ppMultColor(ppPixels[ppGetPixelIndex(int(off1.x / pixelWidth), int(off1.y / pixelHeight))], color(0.2969069646728344 * 255)));
  col = ppAddColor(col, ppMultColor(ppPixels[ppGetPixelIndex(int(off2.x / pixelWidth), int(off2.y / pixelHeight))], color(0.2969069646728344 * 255)));
  col = ppAddColor(col, ppMultColor(ppPixels[ppGetPixelIndex(int(off3.x / pixelWidth), int(off3.y / pixelHeight))], color(0.09447039785044732 * 255)));
  col = ppAddColor(col, ppMultColor(ppPixels[ppGetPixelIndex(int(off1.x / pixelWidth), int(off1.y / pixelHeight))], color(0.09447039785044732 * 255)));
  col = ppAddColor(col, ppMultColor(ppPixels[ppGetPixelIndex(int(off2.x / pixelWidth), int(off2.y / pixelHeight))], color(0.010381362401148057 * 255)));
  col = ppAddColor(col, ppMultColor(ppPixels[ppGetPixelIndex(int(off3.x / pixelWidth), int(off3.y / pixelHeight))], color(0.010381362401148057 * 255)));
  
  pixels[ppGetPixelIndex(x, y)] = col;
}

color ppAddColor(color col1, color col2) {
  return color(red(col1) + red(col2), green(col1) + green(col2), blue(col1) + blue(col2));
}

color ppMultColor(color col1, color col2) {
  return color(red(col1) * red(col2), green(col1) * green(col2), blue(col1) * blue(col2));
}

color ppLerpColor(color col1, color col2, color lerp) {
  return color(lerp(red(col1), red(col2), red(lerp)), lerp(green(col1), green(col2), green(lerp)), lerp(blue(col1), blue(col2), blue(lerp)));
}

int ppGetPixelIndex(int x, int y) {
  if (x < 0)
    x = 0;
  if (x >= width)
    x = width - 1;
    
  if (y < 0)
    y = 0;
  if (y >= height)
    y = height - 1;
    
  return x + y * pixelWidth;
}

void ppRun() {
  loadPixels();
  
  ppPixels = pixels.clone();
  
  if (shake && circle.scoreTime <= globalShakeTime) {
    final float maxShake = 1;
    float shake = streak * 0.1;
    if (shake > maxShake)
      shake = maxShake;
    PVector shakeDir = PVector.fromAngle(radians(random(360))).mult(shakeEffect * shake);

    for (int x = 0; x < pixelWidth; x++)
      for (int y = 0; y < pixelHeight; y++) {
        ppScreenShake(x, y, shakeDir);
        //ppBlur(x, y, new PVector(1, 1));
        //ppBloom(x, y, color(200));
        //ppExposure(x, y, 1.5, 1);
        //ppVignette(x, y, 15, 0.25);
      }
  }
  
  updatePixels();
}
