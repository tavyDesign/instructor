import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Duration duration;
  final TextStyle? textStyle;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final SnackBarBehavior? behavior;
  final SnackBarAction? action;

  const CustomSnackBar({
    super.key,
    required this.message,
    this.backgroundColor = Colors.black87,
    this.duration = const Duration(seconds: 3),
    this.textStyle,
    this.width,
    this.margin,
    this.behavior,
    this.action,
  });

  /// Shows a custom snackbar with the given parameters
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 3),
    TextStyle? textStyle,
    double? width,
    EdgeInsetsGeometry? margin,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
  }) {
    final snackBar = CustomSnackBar(
      message: message,
      backgroundColor: backgroundColor,
      duration: duration,
      textStyle: textStyle,
      width: width,
      margin: margin,
      behavior: behavior,
      action: action,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar._build(context));
  }

  /// Shows a success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    int duration = 3,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.green,
      duration: Duration(seconds: duration),
    );
  }

  /// Shows an error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    int duration = 3,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: duration),
    );
  }

  /// Shows a warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    int duration = 3,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.orange,
      duration: Duration(seconds: duration),
    );
  }

  SnackBar _build(BuildContext context) {
    return SnackBar(
      content: Container(
        width: width,
        alignment: Alignment.center,
        child: Text(
          message,
          style: textStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: behavior ?? SnackBarBehavior.floating,
      margin: margin,
      action: action,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
