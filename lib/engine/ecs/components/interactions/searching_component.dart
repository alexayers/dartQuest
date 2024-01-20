import '../../game_component.dart';
import '../inventory_component.dart';

class SearchingComponent implements GameComponent {
  InventoryComponent searching;

  SearchingComponent(this.searching);

  @override
  String get name => "searching";
}
