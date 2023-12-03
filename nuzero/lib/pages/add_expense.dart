import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  String? _selectedCategory;
  List<String> _categories = [];

  Future<void> addExpense(String name, String category, double value) async {
    CollectionReference expenses =
        FirebaseFirestore.instance.collection('despesas');

    return expenses
        .add({
          'nome': name,
          'categoria': category,
          'valor': value,
          'data': DateTime.now(),
        })
        .then((value) => print("Despesa Adicionada"))
        .catchError((error) => print("Falha ao adicionar despesa: $error"));
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    FirebaseFirestore.instance.collection('categorias').get().then((snapshot) {
      List<String> categories = [];
      for (var doc in snapshot.docs) {
        categories.add(doc['nome']);
      }
      if (mounted) {
        setState(() {
          _categories = categories;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Despesa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome da Despesa',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Categoria da Despesa',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Adicionar Despesa'),
              onPressed: () {
                String name = _nameController.text;
                double? value = double.tryParse(_valueController.text);

                if (name.isNotEmpty &&
                    _selectedCategory != null &&
                    value != null) {
                  addExpense(name, _selectedCategory!, value).then((_) {
                    _clearFormFields();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Despesa adicionada com sucesso.'),
                    ));
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Erro ao adicionar despesa: $error'),
                    ));
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Por favor, preencha todos os campos corretamente.'),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearFormFields() {
    _nameController.clear();
    _valueController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }
}
