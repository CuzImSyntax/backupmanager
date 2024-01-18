import 'package:flutter/material.dart';

/// A custom (styled) TextField used across the project.
///
/// This adds a [Padding] of 10 to the top and the bottom
/// It also adds an [OutlineInputBorder].
/// It can be constructed with a text [label], a [controller] and a [onSubmitted] function.
class TextFieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final void Function(String text)? onSubmitted;

  const TextFieldWidget(
    this.label, {
    Key? key,
    this.controller,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextField(
        onSubmitted: onSubmitted,
        controller: controller,
        style: Theme.of(context).textTheme.bodyLarge,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.bodyLarge,
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
