import java.util.*;

enum ContentCategory {
  PUBLICATION, NEWS, EVENT
}

class Content {
  ContentCategory category;
  StringDict properties = new StringDict();
  ContentImage[] images = null;
  
  Content(ContentCategory category) {
    this.category = category;
  }

  int getNumImages() {
    return images != null ? images.length : 0;
  }
}

class ContentImage {
  String path;
  PImage pimage = null;
  
  ContentImage(String path) {
    this.path = path;
  }
  
  void load() {
    pimage = requestImage(this.path);
  }
  
  void unload() {
    pimage = null;
  }
  
  boolean loaded() {
    return pimage != null && pimage.width > 0;
  }
  
  String getPath() {
    return path;
  }
}

Content getRandomContent() {
  return getRandomContent(null);
}

Content getRandomContent(ContentCategory category) {
  ArrayList<Content> shuffledContents = new ArrayList<>(contents);
  Collections.shuffle(shuffledContents);
  if (category != null) {
    for (Content c : shuffledContents) {
      if (c.category == category) {
        return c;
      }
    }
    return null;
  } else {
    return shuffledContents.get(0);
  }
}

ArrayList<Content> loadContents(Path pathInputDataDir) {
  String[] imageExtensions = {".png", ".jpg", ".jpeg"};
  ArrayList<Content> loadedContents = new ArrayList<Content>();
  JSONObject jsonData = loadJSONObject(pathInputDataDir.resolve("data.json").toString());
  JSONArray contentsData = jsonData.getJSONArray("contents");
  for (int i = 0; i < contentsData.size(); i++) {
    JSONObject contentData = contentsData.getJSONObject(i);
    ContentCategory category;
    if (contentData.getString("category").equalsIgnoreCase("publication")) {
      category = ContentCategory.PUBLICATION;
    } else if (contentData.getString("category").equalsIgnoreCase("news")) {
      category = ContentCategory.NEWS;
    } else if (contentData.getString("category").equalsIgnoreCase("event")) {
      category = ContentCategory.EVENT;
    } else {
      continue;
    }
    Content content = new Content(category);
    String[] properties = (String[]) contentData.keys().toArray(new String[contentData.size()]);
    for (String prop : properties) {
      content.properties.set(prop, contentData.get(prop).toString());
    }
    content.properties.set("dir", pathInputDataDir.resolve(content.properties.get("dir")).toString());
    if (content.properties.hasKey("num_images")) {
      int numImages = Integer.valueOf(content.properties.get("num_images"));
      if (numImages > 0) {
        ArrayList<File> foundImageFiles = new ArrayList<File>();
        File[] foundFiles = new File(content.properties.get("dir")).listFiles();
        for (int k = 0; k < foundFiles.length; k++) {
          String path = foundFiles[k].getAbsolutePath();
          for (String ext : imageExtensions) {
            if (path.toLowerCase().endsWith(ext)) {
              foundImageFiles.add(foundFiles[k]);
              break;
            }
          }
        }
        content.images = new ContentImage[foundImageFiles.size()];
        for (int k = 0; k < foundImageFiles.size(); k++) {
          content.images[k] = new ContentImage(foundImageFiles.get(k).getPath());
        }
        Arrays.sort(content.images, Comparator.comparing(ContentImage::getPath));
      }
    }
    loadedContents.add(content);
  }
  return loadedContents;
}
