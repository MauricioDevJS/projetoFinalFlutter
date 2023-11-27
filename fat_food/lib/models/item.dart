class FoodItemModel {
  final String name;
  final String description;
  final double price;
  final String imagePath;
  bool isFavorite;
  int quantity;

  FoodItemModel({
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
    this.quantity = 1,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 0) {
      quantity--;
    }
  }
}
