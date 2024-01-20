class RenderPerformance {
  static num frameCount = 0;
  static num lastFrame = 0;
  static num frameTime = 0;
  static num deltaTime = 0;

  static void updateFrameTimes() {
    RenderPerformance.frameCount++;
    RenderPerformance.frameTime =
        DateTime.now().millisecondsSinceEpoch - RenderPerformance.lastFrame;
    RenderPerformance.deltaTime = RenderPerformance.frameTime / (1000 / 60);
    RenderPerformance.lastFrame = DateTime.now().millisecondsSinceEpoch;
  }
}
