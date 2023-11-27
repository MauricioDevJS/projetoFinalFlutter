import 'package:fat_food/models/item.dart';
import 'package:flutter/material.dart';

class FoodDetailsModal extends StatelessWidget {
  final FoodItemModel food;

  const FoodDetailsModal(this.food);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 250.0,
              height: 250.0,
              child: Image.asset(
                food.imagePath,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'R\$ ${food.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    food.description,
                    textAlign: TextAlign.center, //
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
