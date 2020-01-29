import 'package:flutter/widgets.dart';

/// Draws a circular animated progress bar.
class LinearProgressBar extends StatefulWidget {
  final Duration animationDuration;
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;
  final double thickness;

  LinearProgressBar({
    Key key,
    this.animationDuration,
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.value,
    this.thickness
  }) : super(key: key);

  @override
  LinearProgressBarState createState() {
    return LinearProgressBarState();
  }
}

class LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  // Used in tweens where a backgroundColor isn't given.
  static const TRANSPARENT = Color(0x00000000);
  AnimationController _controller;

  Animation<double> curve;
  Tween<double> valueTween;
  Tween<Color> backgroundColorTween;
  Tween<Color> foregroundColorTween;

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      duration: this.widget.animationDuration ?? const Duration(seconds: 1),
      vsync: this,
    );

    this.curve = CurvedAnimation(
      parent: this._controller,
      curve: Curves.easeInOut,
    );

    // Build the initial required tweens.
    this.valueTween = Tween<double>(
      begin: 0,
      end: this.widget.value,
    );

    this._controller.forward();
  }

  @override
  void didUpdateWidget(LinearProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.value != oldWidget.value) {
      // Try to start with the previous tween's end value. This ensures that we
      // have a smooth transition from where the previous animation reached.
      double beginValue =
          this.valueTween?.evaluate(this.curve) ?? oldWidget?.value ?? 0;

      // Update the value tween.
      this.valueTween = Tween<double>(
        begin: beginValue,
        end: this.widget.value ?? 1,
      );

      // Clear cached color tweens when the color hasn't changed.
      if (oldWidget?.backgroundColor != this.widget.backgroundColor) {
        this.backgroundColorTween = ColorTween(
          begin: oldWidget?.backgroundColor ?? TRANSPARENT,
          end: this.widget.backgroundColor ?? TRANSPARENT,
        );
      } else {
        this.backgroundColorTween = null;
      }

      if (oldWidget.foregroundColor != this.widget.foregroundColor) {
        this.foregroundColorTween = ColorTween(
          begin: oldWidget?.foregroundColor,
          end: this.widget.foregroundColor,
        );
      } else {
        this.foregroundColorTween = null;
      }

      this._controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: this.curve,
        child: Container(),
        builder: (context, child) {
          final backgroundColor =
              this.backgroundColorTween?.evaluate(this.curve) ??
                  this.widget.backgroundColor;
          final foregroundColor =
              this.foregroundColorTween?.evaluate(this.curve) ??
                  this.widget.foregroundColor;

          return CustomPaint(
            child: child,
            foregroundPainter: LinearProgressBarPainter(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              percentage: this.valueTween.evaluate(this.curve),
              strokeWidth: widget.thickness,
            ),
          );
        },
      ),
    );
  }
}

// Draws the progress bar.
class LinearProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;

  LinearProgressBarPainter({
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.percentage,
    double strokeWidth,
  }) : this.strokeWidth = strokeWidth ?? 10;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset start = Offset.zero;
    final Offset end = Offset(size.width, 0);

    final foregroundPaint = Paint()
      ..color = this.foregroundColor
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double sweepLength = size.width * (this.percentage ?? 0);

    // Don't draw the background if we don't have a background color
    if (this.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = this.backgroundColor
        ..strokeWidth = this.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(start, end, backgroundPaint);
    }

    canvas.drawLine(start, new Offset(sweepLength, 0), foregroundPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as LinearProgressBarPainter);
    return oldPainter.percentage != this.percentage ||
        oldPainter.backgroundColor != this.backgroundColor ||
        oldPainter.foregroundColor != this.foregroundColor ||
        oldPainter.strokeWidth != this.strokeWidth;
  }
}

class LinearProgressCard extends StatefulWidget {
  final double width;
  final double progressPercent;
  final double thickness;

  LinearProgressCard({this.width, this.progressPercent, this.thickness});

  @override
  _LinearProgressCardState createState() => _LinearProgressCardState();
}

class _LinearProgressCardState extends State<LinearProgressCard> {
  double progressPercent = 0;


  @override
  Widget build(BuildContext context) {

    Color foreground = Color.fromRGBO(255, 0, 0, 1);

    if (progressPercent >= 0.8) {
      foreground = Color.fromRGBO(0, 255, 0, 1);
    } else if (progressPercent >= 0.4) {
      foreground = Color.fromRGBO(255, 255, 0, 1);
    }

    Color background = foreground.withOpacity(0.2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: widget.width,
          height: 10,
          child: Container(
//            behavior: HitTestBehavior.translucent,
//          child: Text(widget.progressPercent.toString()),
            child: LinearProgressBar(
              backgroundColor: background,
              foregroundColor: foreground,
              value: widget.progressPercent.clamp(0.0, 1.0),
              thickness: widget.thickness,
            ),
//            onTap: () {
//              final updated =
//                  ((this.progressPercent + 0.1).clamp(0.0, 1.0) * 100);
//              setState(() {
//                this.progressPercent = updated.round() / 100;
//              });
//            },
//            onDoubleTap: () {
//              final updated =
//                  ((this.progressPercent - 0.1).clamp(0.0, 1.0) * 100);
//              setState(() {
//                this.progressPercent = updated.round() / 100;
//              });
//            },
          ),
        ),
//        Text("${this.progressPercent * 100}%"),
      ],
    );
  }
}
