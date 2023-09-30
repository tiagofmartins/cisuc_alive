import java.nio.file.Path;
import java.nio.file.Paths;

Path pathInputDataDir;
ArrayList<Content> contents;

void settings() {
  fnpSize(972, 192, P2D);
  //fnpFullScreen(P2D);
  smooth(8);
}

void setup() {
  frameRate(200);
  background(0);
}

void draw() {
  if (frameCount == 1) {
    return;
  } else if (frameCount == 2) {
    pathInputDataDir = Paths.get(new File(sketchPath()).getParent(), "data_parsed");
    contents = loadContents(pathInputDataDir);
    println("Contents loaded: " + contents.size());
    return;
  }
  
  background(g.backgroundColor);
  
  // TODO draw stuff here
}
