import 'package:flutter/material.dart';

class AdicionarValorInicial extends StatelessWidget {
  final TextEditingController _valorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _valorController,
          decoration: InputDecoration(
            labelText: 'Adicionar Valor Inicial',
          ),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: () {
            final valor = double.tryParse(_valorController.text);
            if (valor != null) {
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Valor inválido'),
                ),
              );
            }
          },
          child: Text('Adicionar'),
        ),
      ],
    );
  }
}
