import 'package:flutter/material.dart';
import 'package:new_shop_app/models/product.dart';

// ignore: must_be_immutable
class SecondImageDetails extends StatefulWidget {
  Product product;
  final Function() saveForm;
  SecondImageDetails(this.product, this.saveForm, {super.key});

  @override
  State<SecondImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<SecondImageDetails> {
  @override
  Widget build(BuildContext context) {
    final imageForm = GlobalKey<FormState>();

    void openOtherImageInput(BuildContext context) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            title: const Text('Rasm linkini kiriting'),
            content: Form(
              key: imageForm,
              child: TextFormField(
                initialValue: widget.product.imgUrl[0],
                decoration: const InputDecoration(
                  label: Text('Rasm URL'),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber,
                    ),
                  ),
                ),
                onSaved: (newValue) {
                  widget.product = Product(
                    id: widget.product.id,
                    title: widget.product.title,
                    imgUrl: [newValue!],
                    ingredients: widget.product.ingredients,
                    quality: widget.product.quality,
                    discount: widget.product.discount,
                    price: widget.product.price,
                    color: widget.product.color,
                    isLike: widget.product.isLike,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mahsulot rasmini kiriting!';
                  } else if (!value.startsWith('http')) {
                    return 'Mahsulot rasmini to\'g\'ri formatda kiring';
                  } else if (!value.startsWith('https')) {
                    return 'Mahsulot rasmini to\'g\'ri formatda kiring';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'BEKOR QILISH',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: widget.saveForm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'QABUL QILISH',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return InkWell(
      onTap: () {
        openOtherImageInput(context);
      },
      child: Container(
        alignment: Alignment.center,
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text('2-Rasm'),
      ),
    );
  }
}
