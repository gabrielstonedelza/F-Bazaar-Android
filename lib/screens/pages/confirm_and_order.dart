import 'package:flutter/material.dart';

class ConfirmAndOrder extends StatefulWidget {
  const ConfirmAndOrder({super.key});

  @override
  State<ConfirmAndOrder> createState() => _ConfirmAndOrderState();
}

class _ConfirmAndOrderState extends State<ConfirmAndOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm and order")),
    );
  }
}
