import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MainAppBar({
    super.key,
    required this.text
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(text),
    );
  }
}
