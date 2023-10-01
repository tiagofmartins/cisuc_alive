import java.nio.file.Path;
import java.nio.file.Paths;

// Parameters
color cisucColor = color(208, 16, 47);
int carouselW = 400;
float carouselVelY = 2.5;
float carouselImagesSpace = 10;
boolean debug = true;

// Variables
PFont fontH1, fontH2, fontH3, fontDebug;
ArrayList<Content> contents;

ContentCard cardTest; // TODO This is just a test. Now create list with several.
Carousel carouselTest; // TODO This is just a test. Now create list with several.

void settings() {
  //fnpSize(972, 192, P2D);
  fnpSize(800, 800, P2D);
  //fnpFullScreen(P2D);
  smooth(8);
}

void setup() {
  frameRate(30);
  background(220);
}

void draw() {
  if (frameCount == 1) {
    return;
  } else if (frameCount == 2) {
    Path pathInputDataDir = Paths.get(new File(sketchPath()).getParent(), "data_parsed");
    contents = loadContents(pathInputDataDir);
    println("Contents loaded: " + contents.size());

    fontH1 = createFont("fonts/SourceSansPro-Semibold.otf", carouselW * 0.060);
    fontH2 = createFont("fonts/SourceSansPro-Regular.otf", carouselW * 0.040);
    fontH3 = createFont("fonts/SourceSansPro-Regular.otf", carouselW * 0.025);
    fontDebug = createFont("fonts/Andale Mono.ttf", 14);
    
    cardTest = new ContentCard(getRandomContent(), carouselW);
    
    // TODO This is just a test.
    carouselTest = new Carousel(width - carouselW, 0, carouselW, height);
    Content randomContentWithImages = null;
    while (true) {
      randomContentWithImages = getRandomContent();
      if (randomContentWithImages.getNumImages() > 100) {
        break;
      }
    }
    
    // TODO This is just a test.
    carouselTest.addContent(randomContentWithImages);
    
    return;
  }

  background(g.backgroundColor);

  // TODO This is just a test.
  carouselTest.display();
  
  // TODO This is just a test.
  image(cardTest.image, mouseX, mouseY);
}

void mouseReleased() {
  // TODO This is just a test.
  cardTest = new ContentCard(getRandomContent(), carouselW);
}

void keyReleased() {
  if (key == 'd') {
    debug = !debug;
  }
}
