import 'package:flutter/material.dart';

class CustomIndicator extends Decoration {
  /// 指示器圆角
  final double radius;

  /// 指示器渐变色，如果设置成同一个色值，则显示器为非渐变色的单色效果
  final List<Color> colors;

  /// 画笔的类型
  final PaintingStyle paintingStyle;

  /// 指示器距离text的位置偏移量，与[indiatorWidth]属性互斥，如果设置了[indiatorWidth]属性，则优先[indiatorWidth]属性
  final EdgeInsets indicatorPadding;

  /// 指示器的宽度，和[indicatorPadding]属性互斥
  final double indicatorWidth;

  /// 画笔的宽度，既指示器的高度
  final double indicatorHeights;

  /// 渐变色指示器的渐变起始点
  final Alignment begin;

  /// 渐变色指示器的渐变终止点
  final Alignment end;

  CustomIndicator({
    this.radius = 3.0,
    this.colors = const [
      Colors.black,
      Colors.black,
    ],
    this.paintingStyle = PaintingStyle.stroke,
    this.indicatorPadding = const EdgeInsets.symmetric(
      horizontal: 2.0,
      vertical: 4.0,
    ),
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.indicatorHeights = 3.0,
    this.indicatorWidth,
  });

  @override
  _CustomBoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _CustomBoxPainter(
      decoration: this,
      onChanged: onChanged,
    );
  }
}

class _CustomBoxPainter extends BoxPainter {
  final CustomIndicator decoration;
  final VoidCallback onChanged;

  _CustomBoxPainter({
    this.decoration,
    this.onChanged,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final bool useIndiatorWidth = (this.decoration.indicatorWidth != null);
    if (useIndiatorWidth) {
      assert(
        this.decoration.indicatorWidth > 0 &&
            this.decoration.indicatorWidth <= configuration.size.width,
        '指示器的宽度必须大于0，且必须小于等于tab的宽度',
      );
    }
    assert(
      this.decoration.indicatorPadding.left >= 0 &&
          this.decoration.indicatorPadding.right >= 0,
      '指示器的左右边距不能为负数',
    );
    assert(
      (this.decoration.indicatorPadding.left +
              this.decoration.indicatorPadding.right) <
          configuration.size.width,
      '指示器的左右边距必须小于选中的tab的宽度',
    );
    assert(
      (this.decoration.indicatorHeights >= 0 &&
          this.decoration.indicatorHeights < configuration.size.width / 2 &&
          this.decoration.indicatorHeights < configuration.size.height / 2),
      '画笔的宽度必须大于等于0，且小于tab的size的二分之一',
    );

    Size indicatorSize = Size(
        (useIndiatorWidth
            ? this.decoration.indicatorWidth
            : (configuration.size.width -
                this.decoration.indicatorPadding.left -
                this.decoration.indicatorPadding.right)),
        this.decoration.indicatorHeights);
    Offset indicatorOffset = Offset(
        (offset.dx + ((configuration.size.width - indicatorSize.width) / 2.0)),
        (offset.dy +
            (configuration.size.height -
                (this.decoration.indicatorPadding.bottom +
                    this.decoration.indicatorPadding.top +
                    indicatorSize.height))));

    final Rect rect = indicatorOffset & indicatorSize;
    final Paint paint = Paint()
      ..style = this.decoration.paintingStyle
      ..strokeWidth = this.decoration.indicatorHeights
      ..shader = LinearGradient(
        colors: this.decoration.colors,
        begin: this.decoration.begin,
        end: this.decoration.end,
      ).createShader(rect);

    final Radius capRadius = Radius.circular(this.decoration.radius);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: capRadius,
        bottomLeft: capRadius,
        topRight: capRadius,
        bottomRight: capRadius,
      ),
      paint,
    );
  }
}
