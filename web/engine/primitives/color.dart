class Color {
  int red;
  int blue;
  int green;
  num alpha;

  Color(this.red, this.green, this.blue, [this.alpha = 1.0]);
}

class Colors {
  static Color black = Color(0, 0, 0, 1);
  static Color white = Color(255, 255, 255, 1);
  static Color ltGray = Color(190, 190, 190, 1);
  static Color red = Color(255, 0, 0, 1);
  static Color blue = Color(0, 0, 255, 1);
  static Color green = Color(0, 100, 0, 1);
  static Color drkGray = Color(100, 100, 100, 1);
}
