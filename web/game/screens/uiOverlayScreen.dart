


import '../../engine/application/gameScreenOverlay.dart';
import '../../engine/logger/logger.dart';
import '../../engine/rendering/animatedSprite.dart';

class UiOverlayScreen implements GameScreenOverlay {

  late AnimatedSprite coins;

  @override
  void init() {

    Map<String, List<String>> coinSprites = {};

    coinSprites["default"] = [
      "../../assets/images/ui/money1.png",
      "../../assets/images/ui/money2.png",
      "../../assets/images/ui/money3.png",
      "../../assets/images/ui/money4.png",
      "../../assets/images/ui/money5.png",
    ];

    coins = AnimatedSprite(coinSprites, "default");


  }

  @override
  void render() {
    //coins.render(10,50,32,32);
  }

}
