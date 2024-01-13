import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/particle.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/utils/mathUtils.dart';

class StormRenderSystem implements GameRenderSystem {
  final List<Particle> _particles = [];

  StormRenderSystem() {
    for (int i = 0; i < 100; i++) {
      _particles.add(refreshParticle(Particle()));
    }
  }

  Particle refreshParticle(Particle particle) {
    particle.x = MathUtils.getRandomBetween(0, Renderer.getCanvasWidth());
    particle.y = MathUtils.getRandomBetween(0, Renderer.getCanvasHeight());
    particle.width = MathUtils.getRandomBetween(25, 500);
    particle.height = MathUtils.getRandomBetween(25, 900);
    particle.color =
        Color(92, 55, 43, MathUtils.getRandomBetween(1, 100) / 1000);
    particle.lifeSpan = MathUtils.getRandomBetween(80, 100);
    particle.velX = MathUtils.getRandomBetween(1, 100) / 10;
    particle.velY = MathUtils.getRandomBetween(1, 100) / 100;
    particle.decayRate = MathUtils.getRandomBetween(1, 5);

    return particle;
  }

  @override
  void process() {
    for (var particle in _particles) {
      Renderer.circle(particle.x, particle.y, particle.width, particle.color);

      particle.x += particle.velX;
      particle.y += particle.velY;
      particle.color.alpha -= 0.005;
      particle.lifeSpan -= 0.004;

      if (particle.lifeSpan < 0 || particle.color.alpha <= 0) {
        refreshParticle(particle);
      }
    }
  }
}
