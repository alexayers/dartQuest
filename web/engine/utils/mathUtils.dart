import 'dart:math';

class MathUtils {
  static num getDecimal(num d) {
    return d - d.floor();
  }

  static Point rotateVector(num vx, num vy, num angle) {
    return Point(
      vx * cos(angle) - vy * sin(angle),
      vx * sin(angle) + vy * cos(angle),
    );
  }

  static bool isPointWithinQuad(
      Point point, num x, num y, num width, num height) {
    if (point.x >= x &&
        point.x <= x + width &&
        point.y >= y &&
        point.y <= y + height) {
      return true;
    } else {
      return false;
    }
  }

  static int getRandomInt(int max) {
    var rng = Random();
    return rng.nextInt(max) + 1;
  }

  static int getRandomBetween(int min, int max) {
    var rng = Random();
    return rng.nextInt(max - min + 1) + min;
  }

  static dynamic getRandomArrayElement(List<dynamic> array) {
    return array[getRandomBetween(0, array.length - 1)];
  }

  static num distanceBetweenTwoPixelCoords(num x1, num y1, num x2, num y2) {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  static num calculateXPercentOfY(int x, int y) {
    return (x / 100) * y;
  }

  static num calculatePercent(int current, int total) {
    return ((current / total) * 100).floor();
  }
}
