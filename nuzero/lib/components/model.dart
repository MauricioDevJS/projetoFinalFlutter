import 'package:cloud_firestore/cloud_firestore.dart';

class Despesa {
  final String id;
  final String nome;
  final String categoria;
  final double valor;
  final String userId;

  Despesa({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.valor,
    required this.userId,
  });

  factory Despesa.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data != null) {
      return Despesa(
        id: doc.id,
        nome: data['nome'] as String? ?? '',
        categoria: data['categoria'] as String? ?? '',
        valor: (data['valor'] is int
                ? (data['valor'] as int).toDouble()
                : data['valor'] as double?) ??
            0.0,
        userId: data['userId'] as String? ?? '',
      );
    } else {
      return Despesa(
        id: doc.id,
        nome: '',
        categoria: '',
        valor: 0.0,
        userId: '',
      );
    }
  }

  get data => null;
}

class Receita {
  final String id;
  final String nome;
  final String categoria;
  final double valor;
  final String userId;

  Receita({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.valor,
    required this.userId,
  });

  factory Receita.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data != null) {
      return Receita(
        id: doc.id,
        nome: data['nome'] as String? ?? '',
        categoria: data['categoria'] as String? ?? '',
        valor: (data['valor'] is int
                ? (data['valor'] as int).toDouble()
                : data['valor'] as double?) ??
            0.0,
        userId: data['userId'] as String? ?? '',
      );
    } else {
      return Receita(
        id: doc.id,
        nome: '',
        categoria: '',
        valor: 0.0,
        userId: '',
      );
    }
  }

  get data => null;
}
