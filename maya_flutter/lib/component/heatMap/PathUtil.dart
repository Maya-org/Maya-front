import 'dart:ui';

/// 四角形生成
Path genSquare(double first_x, double first_y, double second_x, double second_y) {
  Path path = Path();
  path.moveTo(first_x, first_y);
  path.lineTo(second_x, first_y);
  path.lineTo(second_x, second_y);
  path.lineTo(first_x, second_y);
  path.close();
  return path;
}
