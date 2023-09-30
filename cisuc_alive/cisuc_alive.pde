import java.nio.file.Path;
import java.nio.file.Paths;

// Parameters
color cisucColor = color(208, 16, 47);
int columnWidth = 500;

// Variables
ArrayList<Content> contents;
ContentCard cardTest;
PFont fontH1, fontH2, fontH3;

void settings() {
  //fnpSize(972, 192, P2D);
  fnpSize(800, 800, P2D);
  //fnpFullScreen(P2D);
  smooth(8);
}

void setup() {
  frameRate(60);
  background(220);
}

void draw() {
  if (frameCount == 1) {
    return;
  } else if (frameCount == 2) {
    Path pathInputDataDir = Paths.get(new File(sketchPath()).getParent(), "data_parsed");
    contents = loadContents(pathInputDataDir);
    println("Contents loaded: " + contents.size());

    fontH1 = createFont("fonts/SourceSansPro-Semibold.otf", columnWidth * 0.060);
    fontH2 = createFont("fonts/SourceSansPro-Regular.otf", columnWidth * 0.040);
    fontH3 = createFont("fonts/SourceSansPro-Regular.otf", columnWidth * 0.025);

    cardTest = new ContentCard(getRandomContent(), columnWidth);
    return;
  }

  background(g.backgroundColor);

  if (cardTest != null) {
    image(cardTest.image, mouseX, mouseY);
  }
}

void mouseReleased() {
  cardTest = new ContentCard(getRandomContent(), columnWidth);
}
