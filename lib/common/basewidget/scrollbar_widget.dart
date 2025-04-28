import 'package:flutter/material.dart';

class ScrollbarWidget extends StatelessWidget {
  final Widget child;
  const ScrollbarWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
          trackColor: MaterialStateProperty.all(Colors.grey[200]),
          thickness: MaterialStateProperty.all(5),
          radius: const Radius.circular(10),
        ),
      ),
      child: Scrollbar(
        trackVisibility: true,
        thumbVisibility: true,
        thickness: 3,
        interactive: true,
        radius: const Radius.circular(10),
        child: child,
      ),
    );
  }
}
