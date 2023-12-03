import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuzero/components/model.dart';
import 'package:nuzero/pages/add_expense.dart';
import 'package:nuzero/pages/add_revenues.dart';
import 'package:nuzero/pages/graph_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Escolher Opção'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('Receita'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddRevenuesScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text('Despesa'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddExpenseScreen()),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => GraphScreen(
                  despesas: const [],
                )),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NuZero'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TotalBalanceCard(),
              RecentActivityHeader(),
              RecentActivityList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class TotalBalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceText(),
              BalanceAmount(),
              CardBottomRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Balanço Total',
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[600],
      ),
    );
  }
}

class BalanceAmount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'R\$23,345.43',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CardBottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('**** **** **** 1234', style: TextStyle(color: Colors.black)),
        Switch(
          value: true,
          onChanged: (value) {},
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}

class RecentActivityHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Atividade Recente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Ver tudo',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('despesas').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erro ao carregar despesas"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("Nenhuma despesa encontrada"));
            }

            List<Despesa> despesas = snapshot.data!.docs
                .map((doc) => Despesa.fromFirestore(doc))
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: despesas.length,
              itemBuilder: (context, index) {
                Despesa despesa = despesas[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.money_off, color: Colors.white),
                  ),
                  title: Text(despesa.nome),
                  subtitle:
                      Text('${despesa.categoria} - ${despesa.data.toString()}'),
                  trailing: Text(
                    '-R\$ ${despesa.valor.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            );
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('receitas').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Erro ao carregar receitas"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("Nenhuma receita encontrada"));
            }

            List<Receita> receitas = snapshot.data!.docs
                .map((doc) => Receita.fromFirestore(doc))
                .toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                Receita receita = receitas[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.money_off, color: Colors.white),
                  ),
                  title: Text(receita.nome),
                  subtitle:
                      Text('${receita.categoria} - ${receita.data.toString()}'),
                  trailing: Text(
                    'R\$ ${receita.valor.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class HomeBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const HomeBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.purple,
      unselectedItemColor: Colors.white70,
      selectedItemColor: Colors.white,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Adicionar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Gráficos',
        ),
      ],
    );
  }
}
