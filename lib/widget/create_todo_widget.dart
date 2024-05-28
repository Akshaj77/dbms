import 'package:dbms/screens/model_serializers.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CreateProductWidget extends StatefulWidget {
  final void Function(String, String, String) onSubmit;

  const CreateProductWidget({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CreateProductWidget> createState() => _CreateProductWidgetState();
}

class _CreateProductWidgetState extends State<CreateProductWidget> {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              controller: productNameController,
              decoration: const InputDecoration(hintText: 'Product Name'),
              validator: (value) => value != null && value.isEmpty ? 'Product Name is required' : null,
            ),
            TextFormField(
              autofocus: true,
              controller: priceController,
              decoration: const InputDecoration(hintText: 'Price'),
              validator: (value) => value != null && value.isEmpty ? 'Price is required' : null,
            ),
            TextFormField(
              autofocus: true,
              controller: quantityController,
              decoration: const InputDecoration(hintText: 'Quantity'),
              validator: (value) => value != null && value.isEmpty ? 'Quantity is required' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              widget.onSubmit(
                productNameController.text,
                priceController.text,
                quantityController.text,
              );
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}