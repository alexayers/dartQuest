class ColorUtils {
  static String rbgToHex(int red, int green, int blue) {
    try {
      return "#${componentToHex(red)}${componentToHex(green)}${componentToHex(blue)}";
    } catch (e) {
      return "#ffffff";
    }
  }

  static String componentToHex(int component) {
    String hex = component.toRadixString(16);
    return hex.length == 1 ? '0$hex' : hex;
  }
}
