import 'package:flutter/material.dart';

/// Base widget for all pages.
///
/// Returns an Scaffold including an AppBar and centers the given body.
class DefaultContainerWrapper extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;

  const DefaultContainerWrapper({
    required this.body,
    this.title = "BackupManager",
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          height: double.infinity,
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
