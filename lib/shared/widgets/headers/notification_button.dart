import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Badge(child: Icon(Icons.notifications_outlined)),
      onPressed: () {},
    );
  }
}
