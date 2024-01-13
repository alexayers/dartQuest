import '../gameComponent.dart';
import '../gameEntity.dart';

class InventoryComponent implements GameComponent {
  List<GameEntity?> _inventory = [];
  int _maxItems = 6;
  int _currentItemIdx = 0;

  InventoryComponent(this._maxItems) {
    for (int i = 0; i < _maxItems; i++) {
      _inventory.add(null);
    }
  }

  GameEntity? getCurrentItem() {
    return _inventory[_currentItemIdx];
  }

  void dropItem() {
    if (_currentItemIdx > -1) {
      _inventory[_currentItemIdx] = null;
    }
  }

  bool addItem(GameEntity item) {
    for (int i = 0; i < _maxItems; i++) {
      if (_inventory[i] == null) {
        _inventory[i] = item;
        _currentItemIdx = i;
        return true;
      }
    }

    return false;
  }

  List<GameEntity?> get inventory => _inventory;

  int get currentItemIdx => _currentItemIdx;

  set currentItemIdx(int value) {
    _currentItemIdx = value;
  }

  int get maxItems => _maxItems;

  set maxItems(int value) {
    _maxItems = value;
  }

  @override
  String get name => "inventory";
}
