import 'package:fat_food/components/item_card.dart';
import 'package:fat_food/models/item.dart';
import 'package:fat_food/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'favorites_page.dart';

class FoodSelectionPage extends StatefulWidget {
  @override
  _FoodSelectionPageState createState() => _FoodSelectionPageState();
}

class _FoodSelectionPageState extends State<FoodSelectionPage> {
  List<FoodItemModel> foods = [
    FoodItemModel(
      name: 'Hambúrguer',
      description: 'Delicioso hambúrguer com queijo e bacon.',
      price: 15.99,
      imagePath: 'images/hamburger.png',
      isFavorite: false,
    ),
    FoodItemModel(
      name: 'Pizza',
      description: 'Pizza de mussarela com tomate e orégano.',
      price: 12.99,
      imagePath: 'images/pizza.png',
      isFavorite: false,
    ),
    FoodItemModel(
      name: 'Sushi',
      description: 'Sushi variado com peixe fresco.',
      price: 22.99,
      imagePath: 'images/sushi.png',
      isFavorite: false,
    ),
    FoodItemModel(
      name: 'Salada',
      description: 'Salada fresca com mix de folhas e legumes.',
      price: 8.99,
      imagePath: 'images/salad.png',
      isFavorite: false,
    ),
    FoodItemModel(
      name: 'Tacos',
      description: 'Tacos mexicanos com carne e molho apimentado.',
      price: 17.99,
      imagePath: 'images/tacos.png',
      isFavorite: false,
    ),
    FoodItemModel(
      name: 'Massa',
      description: 'Deliciosa massa com molho de tomate e queijo.',
      price: 10.99,
      imagePath: 'images/pasta.png',
      isFavorite: false,
    ),
  ];

  List<FoodItemModel> cartItems = [];
  double subtotal = 0.0;

  void addToCart(FoodItemModel food) {
    final existingFoodIndex =
        cartItems.indexWhere((item) => item.name == food.name);

    if (existingFoodIndex != -1) {
      setState(() {
        cartItems[existingFoodIndex].quantity++;
        subtotal += food.price;
      });
    } else {
      setState(() {
        food.quantity = 1;
        cartItems.add(food);
        subtotal += food.price;
      });
    }
  }

  void removeFromCart(FoodItemModel food) {
    setState(() {
      food.quantity--;

      if (food.quantity <= 0) {
        cartItems.remove(food);
      }

      subtotal -= food.price;

      if (subtotal <= 0) {
        subtotal = 0.0;
      }
    });
  }

  void updateFavoriteStatus(List<FoodItemModel> favoriteItems) {
    setState(() {
      for (final food in foods) {
        food.isFavorite = favoriteItems.contains(food);
      }
    });
  }

  void toggleFavorite(FoodItemModel food) {
    setState(() {
      food.toggleFavorite();
    });
  }

  List<FoodItemModel> getFavoriteItems() {
    return foods.where((food) => food.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleção de Comidas'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {
              final favoriteItems = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(getFavoriteItems()),
                ),
              );
              if (favoriteItems != null) {
                updateFavoriteStatus(favoriteItems);
              }
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return FoodDetailsModal(food);
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: FoodItemCard(
                food: food,
                addToCart: addToCart,
                removeFromCart: removeFromCart,
                toggleFavorite: toggleFavorite,
                imageSize: 300.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
