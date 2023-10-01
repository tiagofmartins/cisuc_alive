import java.nio.file.Path;
import java.nio.file.Paths;

// Parameters
color cisucColor = color(208, 16, 47);
int carouselW = 400;
float carouselVelY = 3.2;
float carouselImagesSpace = 10;

// Variables
PFont fontH1, fontH2, fontH3;
ArrayList<Content> contents;
ContentCard cardTest;
Carousel carouselTest;

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

    cardTest = new ContentCard(getRandomContent(), carouselW);
    
    carouselTest = new Carousel(width - carouselW, 0, carouselW, height);
    Content randomContentWithImages = null;
    while (true) {
      randomContentWithImages = getRandomContent();
      if (randomContentWithImages.getNumImages() > 5) {
        break;
      }
    }
    println("------>" + randomContentWithImages.getNumImages());
    carouselTest.addContent(randomContentWithImages);
    
    return;
  }

  background(g.backgroundColor);

  
  carouselTest.display();
  image(cardTest.image, mouseX, mouseY);
}

void mouseReleased() {
  cardTest = new ContentCard(getRandomContent(), carouselW);
}
