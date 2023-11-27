import 'package:fat_food/models/item.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final List<FoodItemModel> favoriteItems;

  const FavoritesPage(this.favoriteItems);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<FoodItemModel> _favorites = [];

  @override
  void initState() {
    super.initState();
    _favorites = List.from(widget.favoriteItems);
  }

  void removeFavorite(FoodItemModel food) {
    setState(() {
      food.toggleFavorite();
      widget.favoriteItems.remove(food);
      Navigator.pop(context, widget.favoriteItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final food = _favorites[index];
          return ListTile(
            title: Text(food.name),
            trailing: IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.red,
              onPressed: () {
                removeFavorite(food);
              },
            ),
          );
        },
      ),
    );
  }
}
