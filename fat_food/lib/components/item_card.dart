import 'package:fat_food/models/item.dart';
import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItemModel food;
  final Function(FoodItemModel) addToCart;
  final Function(FoodItemModel) removeFromCart;
  final Function(FoodItemModel) toggleFavorite;
  final double imageSize;

  const FoodItemCard({
    required this.food,
    required this.addToCart,
    required this.removeFromCart,
    required this.toggleFavorite,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              food.imagePath,
              width: imageSize,
              height: imageSize,
            ),
          ),
          ListTile(
            title: Text(food.name),
            subtitle: Text(food.description),
            trailing: IconButton(
              icon: Icon(
                food.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: food.isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                toggleFavorite(food);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$ ${food.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    addToCart(food);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
