import 'dart:html';
import 'dart:math';

import '../logger/logger.dart';
import '../primitives/color.dart';
import '../utils/colorUtils.dart';
import 'font.dart';

class Renderer {
  static late CanvasElement _canvas;
  static late CanvasRenderingContext2D _ctx;
  static late CanvasElement _calculationCanvas;
  static late CanvasRenderingContext2D _calculationCanvasCtx;

  static late CanvasElement _dataCanvas;
  static late CanvasRenderingContext2D _dataContext;

  static void init() {
    var container = DivElement();
    container.id = "container";

    logger(LogType.info, "Resolution W: 800 H: 600");

    _canvas = CanvasElement(width: 800, height: 600);
    _canvas.id = "game";
    container.append(_canvas);

    document.body?.append(container);

    _ctx = _canvas.getContext('2d') as CanvasRenderingContext2D;
    _ctx.imageSmoothingEnabled = false;

    _calculationCanvas = CanvasElement();
    _calculationCanvasCtx =
        _calculationCanvas.getContext('2d') as CanvasRenderingContext2D;

    _dataCanvas = CanvasElement(width: 800, height: 600);
    _dataContext = _dataCanvas.getContext('2d') as CanvasRenderingContext2D;
    disabledImageSmoothing();
  }

  static void clearScreen() {
    _ctx.clearRect(0, 0, _canvas.width as num, _canvas.height as num);
  }

  static void setColor(Color color) {
    _ctx.fillStyle = ColorUtils.rbgToHex(color.red, color.green, color.blue);
  }

  static void resize() {
    _canvas.width = window.innerWidth;
    _canvas.height = window.innerHeight;
    _ctx.imageSmoothingEnabled = false;
  }

  static void renderImage(
      ImageElement image, num x, num y, int width, int height,
      [bool flip = false]) {
    if (flip) {
      _ctx.translate(x + width, y);
      _ctx.scale(-1, 1);

      _ctx.drawImageScaled(image, 0, 0, width, height);

      _ctx.setTransform(1, 0, 0, 1, 0, 0);
    } else {
      _ctx.drawImageScaled(image, x, y, width, height);
    }
  }

  static void renderClippedImage(
      ImageElement image,
      num sourceX,
      num sourceY,
      num sourceWidth,
      num sourceHeight,
      num destX,
      num destY,
      num destWidth,
      num destHeight) {
    _ctx.drawImageScaledFromSource(image, sourceX, sourceY, sourceWidth,
        sourceHeight, destX, destY, destWidth, destHeight);
  }

  static num calculateTextWidth(String text, String font) {
    _calculationCanvasCtx.font = font;
    TextMetrics metrics = _calculationCanvasCtx.measureText(text);
    return metrics.width!;
  }

  static void print(String msg, int x, int y, Font font) {
    _ctx.font = "${font.style} ${font.size}px ${font.family}";
    _ctx.fillStyle =
        ColorUtils.rbgToHex(font.color.red, font.color.green, font.color.blue);

    setAlpha(font.color.alpha);

    _ctx.fillText(msg, x, y);

    setAlpha(1);
  }

  static List<String> getLines(String text, int maxWidth) {
    List<String> words = text.split(" ");
    List<String> lines = [];
    String currentLine = words[0];

    for (int i = 1; i < words.length; i++) {
      String word = words[i];
      num? width = _ctx.measureText("$currentLine $word").width;
      if (width! < maxWidth) {
        currentLine += " $word";
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }

    lines.add(currentLine);
    return lines;
  }

  static void fillAndClose() {
    _ctx.fill();
    _ctx.closePath();
  }

  static void beginPath() {
    _ctx.beginPath();
  }

  static void circle(num x, num y, num radius, Color color) {
    _ctx.beginPath();

    setColor(color);
    setAlpha(color.alpha);

    _ctx.arc(x, y, radius, 0, 2 * pi, false);

    _ctx.fill();
    _ctx.closePath();
    setAlpha(1);
  }

  static void line(num x1, num y1, num x2, num y2, num width, Color color) {
    _ctx.beginPath();

    _ctx.moveTo(x1, y1);
    _ctx.lineTo(x2, y2);
    _ctx.lineWidth = width;
    _ctx.strokeStyle = ColorUtils.rbgToHex(color.red, color.green, color.blue);
    setAlpha(color.alpha);
    _ctx.stroke();
  }

  static void rect(num x, num y, num width, num height, Color color) {
    _ctx.beginPath();

    setColor(color);
    setAlpha(color.alpha);

    Renderer._ctx.rect(x, y, width, height);

    _ctx.fill();
    _ctx.closePath();
    setAlpha(1);
  }

  static void setAlpha(num alpha) {
    _ctx.globalAlpha = alpha;
  }

  static int getCanvasWidth() {
    return _canvas.width!;
  }

  static int getCanvasHeight() {
    return _canvas.height!;
  }

  static void saveContext() {
    _ctx.save();
  }

  static void restoreContext() {
    _ctx.restore();
  }

  static void enableImageSmoothing() {
    _ctx.imageSmoothingEnabled = true;
  }

  static void disabledImageSmoothing() {
    _ctx.imageSmoothingEnabled = false;
  }

  static void translate(num x, num y) {
    _ctx.translate(x, y);
  }

  static void rotate(num angle) {
    _ctx.rotate(-(angle - pi * 0.5));
  }
}
