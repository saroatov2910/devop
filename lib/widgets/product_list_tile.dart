import 'package:devop/models/products/product.dart';
import 'package:flutter/material.dart';
import 'package:your_app_name/models/products/product.dart';

class ProductListTile extends StatefulWidget {
  final Product product;
  final VoidCallback;


  const ProductListTile ({
    super.key,
    required this.product,
    required this.onTap ;
  });

   @override
  Widget build(BuildContext context) {
    return  Container(
      //Add vertical margin to product list tile
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color:product.cheked ?Colors.white[700] :Color.grey[200],
        border:Radius.circular(12)
      ),
          title: Text(
          product.nameProduct,
          style: TextStyle(
          color: product.checked ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
          subtitle: Text(
          product.description,
          style: TextStyle(
            color: product.checked ? Colors.white70 : Colors.black54,
          ),
        ),
          trailing: product.checked
            ? const Icon(Icons.check_box, color: Colors.white)
            : const Icon(Icons.check_box_outline_blank),
        onTap: onTap,
    );
  }




}
