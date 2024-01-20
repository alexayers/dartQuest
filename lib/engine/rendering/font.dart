import '../primitives/color.dart';

enum FontFamily { arial }

enum FontStyle { bold, italic, normal }

class Font {
  String family = FontFamily.arial.toString();
  int size;
  FontStyle style = FontStyle.normal;
  Color color = Colors.white;

  Font(this.family, this.size, this.color);
}
