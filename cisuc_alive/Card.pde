class ContentCard {

  Content content;
  PImage image = null;
  int cardWidth;
  int cardHeight;
  float marginHor;
  float marginVer;
  
  ContentCard(Content content, int cardWidth) {
    this.content = content;
    this.cardWidth = cardWidth;
    this.cardHeight = this.cardWidth * 3; // This value is adjusted when the card is generated
    this.marginHor = this.cardWidth * 0.05;
    this.marginVer = marginHor * 1.25;
    generate();
  }

  private void generate() {
    PGraphics pg = createGraphics(cardWidth, cardHeight);
    pg.beginDraw();
    pg.background(cisucColor);
    pg.fill(255);

    String text;
    float textH;
    float currY = marginVer;
    float utilW = cardWidth - marginHor * 2;

    if (content.category == ContentCategory.PUBLICATION) {
      text = content.properties.get("subcategory") + " · " + content.properties.get("year");
      textH = myDrawText(pg, text, marginHor, currY, utilW, fontH3, fontH3.getSize(), fontH3.getSize() * 1);
      currY += textH + pg.textSize * 0.75;

      text = content.properties.get("title");
      textH = myDrawText(pg, text, marginHor, currY, utilW, fontH1, fontH1.getSize(), fontH1.getSize() * 1.15);
      currY += textH + pg.textSize * 0.75;

      text = content.properties.get("authors");
      textH = myDrawText(pg, text, marginHor, currY, utilW, fontH2, fontH2.getSize(), fontH2.getSize() * 1.15);
      currY += textH;
      
    } else if (content.category == ContentCategory.NEWS) {

      if (content.properties.hasKey("when")) {
        text = content.properties.get("when");
        textH = myDrawText(pg, text, marginHor, currY, utilW, fontH3, fontH3.getSize(), fontH3.getSize() * 1);
        currY += textH + pg.textSize * 0.75;
      }

      text = content.properties.get("header");
      textH = myDrawText(pg, text, marginHor, currY, utilW, fontH1, fontH1.getSize(), fontH1.getSize() * 1.15);
      currY += textH + pg.textSize * 0.75;

      if (content.properties.hasKey("description")) {
        text = content.properties.get("description");
        textH = myDrawText(pg, text, marginHor, currY, utilW, fontH2, fontH2.getSize(), fontH2.getSize() * 1.15);
        currY += textH;
      }
      
    } else if (content.category == ContentCategory.EVENT) {

      text = content.properties.get("when") + " · " + content.properties.get("where");
      textH = myDrawText(pg, text, marginHor, currY, cardWidth - marginHor * 2, fontH3, fontH3.getSize(), fontH3.getSize() * 1);
      currY += textH + pg.textSize * 0.75;

      text = content.properties.get("header");
      textH = myDrawText(pg, text, marginHor, currY, utilW, fontH1, fontH1.getSize(), fontH1.getSize() * 1.15);
      currY += textH + pg.textSize * 0.75;

      if (content.properties.hasKey("description")) {
        text = content.properties.get("description");
        textH = myDrawText(pg, text, marginHor, currY, utilW, fontH2, fontH2.getSize(), fontH2.getSize() * 1.15);
        currY += textH;
      }
      
    }
    pg.endDraw();
    
    cardHeight = int(currY + marginVer);
    if (cardHeight > pg.height) {
      cardHeight = pg.height * 2;
      generate();
    } else {
      image = pg.get(0, 0, pg.width, cardHeight);
    }
  }
}

float myDrawText(PGraphics pg, String text, float x, float y, float w, PFont font, float textSize, float textLeading) {
  pg.pushStyle();
  pg.textFont(font);
  pg.textSize(textSize);
  pg.textLeading(textLeading);
  float textBoxHeight = getTextBoxHeight(text, font, textSize, textLeading, w);
  pg.text(text, x, y, w, textBoxHeight * 1.1);
  pg.popStyle();
  return textBoxHeight;
}

float getTextBoxHeight(String text, PFont font, float fontSize, float textLeading, float boxWidth) {
  pushStyle();
  textFont(font);
  textSize(fontSize);
  textLeading(textLeading);
  
  String text2 = text.replaceAll("\n", " <br> ");
  text2 = text2.replaceAll("\\s+", " ");
  String[] words = text2.split(" ");

  int numLines = 1;
  float currLineWidth = 0;
  float whiteSpaceWidth = textWidth(" ");
  for (int w = 0; w < words.length; w++) {
    if (words[w].equals("<br>")) {
      numLines += 1;
      currLineWidth = 0;
    } else {
      float currWordWidth = textWidth(words[w]);
      currLineWidth += currWordWidth;
      if (currLineWidth > boxWidth) {
        numLines += 1;
        currLineWidth = currWordWidth;
      } else {
        currLineWidth += whiteSpaceWidth;
      }
    }
  }
  
  float boxHeight = numLines * g.textLeading;
  popStyle();
  return boxHeight;
}
