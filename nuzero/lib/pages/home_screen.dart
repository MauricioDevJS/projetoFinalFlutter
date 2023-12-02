import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuzero/components/model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Despesa>> fetchDespesas() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('despesas').get();

    List<Despesa> despesas = snapshot.docs.map((doc) {
      return Despesa.fromFirestore(doc);
    }).toList();

    return despesas;
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
              RecentActivityList(futureDespesas: fetchDespesas()),
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
      'Total Balance',
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
      '\$23,345.43',
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
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'View All',
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
  final Future<List<Despesa>> futureDespesas;

  RecentActivityList({required this.futureDespesas});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Despesa>>(
      future: futureDespesas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar despesas"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Nenhuma despesa encontrada"));
        }

        List<Despesa> despesas = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: despesas.length,
          itemBuilder: (context, index) {
            Despesa despesa = despesas[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Icon(Icons.account_balance_wallet, color: Colors.white),
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
          label: 'Nova Despesa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Gráficos',
        ),
      ],
    );
  }
}
