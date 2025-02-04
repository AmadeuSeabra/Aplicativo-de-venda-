import 'package:bike3/CheckoutPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _messaging = FirebaseMessaging.instance;

Future<void> subscribeToTopic() async {
  await _messaging.subscribeToTopic('comments');
}

class CartPage extends StatefulWidget {
  final Map<Map<String, String>, int> cartItems; // Produto com sua quantidade

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Calcula o valor total do carrinho
  double getTotal() {
    return widget.cartItems.entries.fold(
      0.0,
      (sum, entry) {
        final price = double.parse(
          entry.key['price']!.replaceAll(RegExp(r'[^\d.]'), ''),
        );
        return sum + (price * entry.value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = widget.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        backgroundColor: const Color.fromARGB(255, 66, 35, 151),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 106, 33, 139),
              Color.fromARGB(255, 82, 25, 240),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: cartItems.isEmpty
            ? const Center(
                child: Text(
                  "Seu carrinho está vazio!",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems.keys.elementAt(index);
                          final quantity = cartItems[item]!;
                          return Card(
                            color: Colors.white.withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Image.network(
                                item['image']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                item['name']!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Preço: ${item['price']}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  Text(
                                    "Quantidade: $quantity",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove,
                                        color: Colors.deepPurple),
                                    onPressed: () {
                                      setState(() {
                                        if (cartItems[item]! > 1) {
                                          cartItems[item] = quantity - 1;
                                        } else {
                                          cartItems.remove(item);
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Colors.deepPurple),
                                    onPressed: () {
                                      setState(() {
                                        cartItems[item] = quantity + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Total e botão de finalizar compra
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          Text(
                            "Total: R\$ ${getTotal().toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CheckoutPage(total: getTotal()),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 66, 35, 151),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 40.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              "Finalizar Compra",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
