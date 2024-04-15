import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Order IHP',
    theme: ThemeData(
      primaryColor: Colors.orange.shade50,
      primarySwatch: Colors.deepOrange,
    ),
    home: IntroScreen(), // Navigate to the IntroScreen first
  ));
}

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context), // Use the same theme as MaterialApp
      child: Scaffold(
          backgroundColor:Colors.orange.shade50,
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(119, 42, 3, 0.612),
          title: Text('Welcome to IHP'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                'images/LOGO.png', // Change the path to your image
                width: 200, // Adjust the width as needed
                height: 200, // Adjust the height as needed
                fit: BoxFit.cover, // Adjust the fit property as needed
              ),
              SizedBox(height: 20),
              Text(
                'Steps to Place your Order:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.orange.shade50,
                ),
              ),
              SizedBox(height: 20),
              Text(
                '1. Browse through the available products.\n'
                    '2. Tap on the product to view different variants.\n'
                    '3. Add desired quantity to your cart.\n'
                    '4. Review your order and proceed to summary by clicking on the Tick button!.\n'
                    '   It is that simple!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                  height: 1.5, // Adjust line spacing
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => OrderNavigation()),
                  );
                },
                child: Text(
                  'Start Ordering',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.orange.shade50
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderNavigation extends StatefulWidget {
  @override
  _OrderNavigationState createState() => _OrderNavigationState();
}

class _OrderNavigationState extends State<OrderNavigation> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    OrderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context), // Use the same theme as MaterialApp
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Order',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Map<String, List<Map<String, dynamic>>> products = {
    'Munch': [
      {'variant': '25g', 'price': 20, 'photo': 'images/MUNCH.jpg'},
      {'variant': '50g', 'price': 40, 'photo': 'images/MUNCH.jpg'},
      {'variant': '100g', 'price': 80, 'photo': 'images/MUNCH.jpg'},
    ],
    'DairyMilk': [
      {'variant': '10g - Regular', 'price': 10, 'photo': 'images/dairy.jpg'},
      {'variant': '35g - Regular', 'price': 30, 'photo': 'images/dairy.jpg'},
      {'variant': '110g - Regular', 'price': 80, 'photo': 'images/dairy.jpg'},
      {'variant': '110g - Silk', 'price': 95, 'photo': 'images/dairy.jpg'},
    ],
    'KitKat': [
      {'variant': '25g', 'price': 25, 'photo': 'images/kitkat.jpg'},
      {'variant': '50g', 'price': 50, 'photo': 'images/kitkat.jpg'},
      {'variant': '100g', 'price': 100, 'photo': 'images/kitkat.jpg'},
    ],
    'FiveStar': [
      {'variant': '25g', 'price': 15, 'photo': 'images/5star.png'},
      {'variant': '50g', 'price': 30, 'photo': 'images/5star.png'},
      {'variant': '100g', 'price': 60, 'photo': 'images/5star.png'},
    ],
    'Perk': [
      {'variant': '25g', 'price': 15, 'photo': 'images/perk.jpg'},
      {'variant': '50g', 'price': 30, 'photo': 'images/perk.jpg'},
      {'variant': '100g', 'price': 60, 'photo': 'images/perk.jpg'},
    ],
  };

  Map<String, int> order = {}; //to store users order
  double total = 0;

  void addToOrder(String product, String variant, int quantity) {
    final key = '$product-$variant';
    final currentQuantity = order[key];
    if (currentQuantity != null) {
      order[key] = currentQuantity + quantity;
    } else {
      order[key] = quantity;
    }
    setState(() {});
  }

  void decrementOrder(String product, String variant) {
    final key = '$product-$variant';
    if (order.containsKey(key) && order[key]! > 0) {
      int currentQuantity = order[key]!;
      setState(() {
        order[key] = currentQuantity - 1;
      });
    }
  }

  void navigateToSummaryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SummaryScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(119, 42, 3, 0.612),
        leading: Image.asset('images/LOGO.png'),
        title: Text('Place your Order'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          String productName = products.keys.elementAt(index);
          return ExpansionTile(
            title: Text(productName),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: products[productName]?.length ?? 0,
                itemBuilder: (context, idx) {
                  var variant = products[productName]![idx];
                  return ListTile(
                    leading: Image.asset(variant['photo']),
                    title: Text(variant['variant']),
                    subtitle: Text('Price: ₹${variant['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            decrementOrder(productName, variant['variant']);
                          },
                        ),
                        Text(
                          '${order.containsKey('$productName-${variant['variant']}') ? order['$productName-${variant['variant']}'] : 0}',
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            addToOrder(productName, variant['variant'], 1);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToSummaryScreen(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final Map<String, int> order;

  SummaryScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.orange.shade50,
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(119, 42, 3, 0.612),
          leading: Image.asset('images/LOGO.png'),
        title: Text(
          'Order Summary'
        ),
      ),
      body: ListView(
        children: order.entries.map((entry) {
          return ListTile(
            title: Text(
              entry.key
            ),
            subtitle: Text(
              'Quantity: ${entry.value}'
            ),
          );
        }).toList(),
      ),
    );
  }
}
