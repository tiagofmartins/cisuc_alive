class Carousel {

  int yTopLimitToLoad = -200;
  int yBottomLimitToLoad = height + 200;

  float x, y, w, h;
  ArrayList<CarouselImg> images = new ArrayList<CarouselImg>();

  Carousel(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    // Load needed images and remove unnecessary ones
    for (int i = images.size() - 1; i >= 0; i--) {
      CarouselImg img = images.get(i);
      if (img.y + img.h < yTopLimitToLoad) { // If image is above top limit
        images.remove(i);
      } else if (img.y < yBottomLimitToLoad) { // If image is above bottom limit
        if (!img.loaded()) {
          if (i == 0 || images.get(i - 1).loaded()) {
            // Load this image only if it is on top or if the above image is loaded
            img.load();
          }
        }
      }
    }

    // Move images
    for (int i = 0; i < images.size(); i++) {
      CarouselImg img = images.get(i);
      if (i == 0) {
        img.y -= carouselVelY;
      } else {
        CarouselImg aboveImg = images.get(i - 1);
        img.y = aboveImg.y + aboveImg.h + carouselImagesSpace;
      }
    }

    // Display images
    for (CarouselImg img : images) {
      img.display(x);
    }

    // Debug
    if (debug) {
      
      // Draw bounds
      noFill();
      strokeWeight(1);
      stroke(0);
      rect(x, y, w, h);
      line(x, y, x + w, y + h);

      // Display number of images loaded
      int imagesLoaded = 0;
      for (CarouselImg img : images) {
        if (img.loaded()) {
          imagesLoaded++;
        }
      }
      fill(0);
      textFont(fontDebug, fontDebug.getSize());
      text(imagesLoaded + "/" + images.size() + " images loaded", x + 20, y + 20);      
    }
  }

  void addContent(Content c) {
    for (int i = 0; i < c.pathsImages.length; i++) {
      CarouselImg ci = new CarouselImg(c.pathsImages[i], carouselW);
      images.add(ci);
    }
  }

  float getBottomImageY() {
    if (images.isEmpty()) {
      return 0;
    } else {
      CarouselImg bottomImage = images.get(images.size() - 1);
      return bottomImage.y + bottomImage.h;
    }
  }
}

class CarouselImg {

  String path;
  PImage image = null;
  float y = 0;
  float w, h;
  boolean loadRequested = false;
  boolean sizeCalculated = false;

  CarouselImg(String path, float w) {
    this.path = path;
    this.w = w;
  }

  void display(float x) {
    if (!loaded()) {
      return;
    }
    if (!sizeCalculated) {
      float scaling = w / (float) image.width;
      h = image.height * scaling;
      sizeCalculated = true;
    }
    image(image, x, y, w, h);
    noFill();
    stroke(200);
    strokeWeight(1);
    rect(x, y, w, h);
  }

  void load() {
    if (!loadRequested) {
      image = requestImage(path);
      loadRequested = true;
    }
  }

  boolean loaded() {
    return image != null && image.width > 0;
  }
}

float[] resizeToFitInside(float inputW, float inputH, float maxW, float maxH) {
  float aspectRatioInput = inputW / inputH;
  float aspectRatioMax = maxW / maxH;
  float outputW, outputH;
  if (aspectRatioMax >= aspectRatioInput) {
    outputW = maxH * aspectRatioInput;
    outputH = maxH;
  } else {
    outputW = maxW;
    outputH = maxW / aspectRatioInput;
  }
  return new float[]{outputW, outputH};
}
