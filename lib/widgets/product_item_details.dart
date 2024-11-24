import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../models/product.dart';

class ProductItemDetails extends StatefulWidget {
  const ProductItemDetails({
    super.key,
    required this.deviceHieght,
    required this.product,
  });

  final double deviceHieght;
  final Product product;

  @override
  State<ProductItemDetails> createState() => _ProductItemDetailsState();
}

class _ProductItemDetailsState extends State<ProductItemDetails> {
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Container(
      margin: const EdgeInsets.only(top: 330),
      height: widget.deviceHieght * 0.54,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    widget.product.discount > 0
                        ? Text(
                            '${widget.product.discount}% Chegirma',
                            style: TextStyle(
                              color: widget.product.color,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    widget.product.quality.isNotEmpty
                        ? Text(
                            widget.product.quality,
                            style: TextStyle(
                              color: widget.product.color,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.product.toggleLike(auth.toket!, auth.userId!);
                    });
                  },
                  icon: Icon(
                    widget.product.isLike
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.product.ingredients,
              style:  TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: widget.product.imgUrl.map(
                (image) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(5),
                    alignment: Alignment.center,
                    clipBehavior: Clip.hardEdge,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: image.startsWith('assets')
                        ? Image.asset(
                            image,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                  );
                },
              ).toList(),
            )
          ],
        ),
      ),
    );
  }
}
