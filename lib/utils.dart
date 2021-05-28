class Utils{
  static String getImageUrl(String description){
    String regularExpression = "src=\"(.*)\" ></a>";
    final regexp = RegExp(regularExpression);
    final match = regexp.firstMatch(description);

    return (match != null) ? match.group(1) : '';
  }

  static String getContent(String description){
    String regularExpression = "</br>(.*)";
    final regexp = RegExp(regularExpression);
    final match = regexp.firstMatch(description);

    if(match != null){
      return match.group(1);
    }else{
      return '';
    }


  }
}