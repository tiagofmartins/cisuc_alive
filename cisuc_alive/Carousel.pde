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
      if (img.y + img.h < yTopLimitToLoad) {
        images.remove(i);
      } else if (img.y < yBottomLimitToLoad && img.loaded() == false) {
        img.load(); // Bug here
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
    
    for (CarouselImg img : images) {
      img.display(x);
    }
    
    int loadedImages = 0;
    for (CarouselImg img : images) {
      if (img.loaded()) {
        loadedImages++;
      }
    }
    println(loadedImages);
    
    /*noFill();
    strokeWeight(1);
    stroke(255, 100, 100);
    rect(x, y, w, h);
    line(x, y, x + w, y + h);*/
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
  float w = 0;
  float h = 0;
  boolean loadRequested = false;
  boolean sizeCalculated = false;
  CarouselImg imgAbove = null;

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

  void unload() {
    image = null;
    loadRequested = false;
    sizeCalculated = false;
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
