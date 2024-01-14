import '../../../engine/ecs/gameRenderSystem.dart';
import '../../../engine/primitives/color.dart';
import '../../../engine/rendering/particle.dart';
import '../../../engine/rendering/renderer.dart';
import '../../../engine/utils/mathUtils.dart';

class FogRenderSystem implements GameRenderSystem {
  List<Particle> _particles = [];

  FogRenderSystem() {
    for (int i = 0; i < 100; i++) {
      _particles.add(refreshParticle(Particle()));
    }
  }

  Particle refreshParticle(Particle particle) {
    particle.x = MathUtils.getRandomBetween(0, Renderer.getCanvasWidth());
    particle.y = MathUtils.getRandomBetween(0, Renderer.getCanvasHeight());
    particle.width = MathUtils.getRandomBetween(500, 1200);
    particle.height = MathUtils.getRandomBetween(500, 1200);
    particle.color =
        Color(120, 120, 120, 0.006);
    particle.lifeSpan = 900;
    particle.velX = 0;
    particle.velY = 0;
    particle.decayRate = 0.1;

    return particle;
  }

  @override
  void process() {
    for (var particle in _particles) {
      Renderer.circle(particle.x, particle.y, particle.width, particle.color);

      particle.x += particle.velX;
      particle.y += particle.velY;
      particle.color.alpha -= particle.decayRate;
      particle.lifeSpan -= particle.decayRate;

      if (particle.lifeSpan < 0 || particle.color.alpha <= 0) {
        refreshParticle(particle);
      }
    }
  }
}
