import 'package:flutter/material.dart';

//ToDo Make controller optional
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
