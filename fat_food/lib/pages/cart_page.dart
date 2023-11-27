import 'package:fat_food/models/item.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<FoodItemModel> cartItems;

  CartPage(this.cartItems);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<FoodItemModel> _cartItems = [];
  double subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
    _calculateSubtotal();
  }

  void _calculateSubtotal() {
    subtotal =
        _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addToCart(FoodItemModel food) {
    final existingFoodIndex =
        _cartItems.indexWhere((item) => item.name == food.name);

    if (existingFoodIndex != -1) {
      setState(() {
        _cartItems[existingFoodIndex].quantity++;
        _calculateSubtotal();
      });
    } else {
      setState(() {
        food.quantity = 1;
        _cartItems.add(food);
        _calculateSubtotal();
      });
    }
  }

  void removeFromCart(FoodItemModel food) {
    setState(() {
      food.quantity--;
      if (food.quantity <= 0 || food.quantity == false) {
        _cartItems.remove(food);
      }
      _calculateSubtotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final food = _cartItems[index];
          if (food.quantity <= 0) {
            return Container();
          }
          return Card(
            child: ListTile(
              leading: Image.asset(
                food.imagePath,
                width: 48.0,
                height: 48.0,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(food.name),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          removeFromCart(food);
                        },
                      ),
                      Text('Quantidade: ${food.quantity.toString()}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          addToCart(food);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Text(
                'Valor: R\$ ${(food.price * food.quantity).toStringAsFixed(2)}',
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Subtotal: R\$ ${subtotal.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              height: 35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('Finalizar Pedido'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
