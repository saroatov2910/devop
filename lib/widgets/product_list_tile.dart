import 'dart:ffi';

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
}
