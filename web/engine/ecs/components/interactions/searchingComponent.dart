import '../../gameComponent.dart';
import '../inventoryComponent.dart';

class SearchingComponent implements GameComponent {
  InventoryComponent searching;

  SearchingComponent(this.searching);

  @override
  String get name => "searching";
}
