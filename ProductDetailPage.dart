import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importação da biblioteca intl
import 'CartPage.dart'; // Certifique-se de importar o arquivo da página do carrinho
import 'CommentsPage.dart'; // Importar a nova página de comentários

// Mapa global para armazenar os itens do carrinho e suas quantidades
Map<Map<String, String>, int> cart = {};

class ProductDetailPage extends StatelessWidget {
  final Map<String, String> product;

  const ProductDetailPage({super.key, required this.product});

  // Função para formatar data de comentário
  String formatDate(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Função para adicionar comentário no Firestore
    void addComment(String comment) async {
      if (comment.isEmpty || comment.length > 200 || currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentUser == null
                  ? "Você precisa estar logado para comentar."
                  : "Comentário inválido! Verifique se o texto está entre 1 e 200 caracteres.",
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        await firestore.collection('comments').add({
          'productName': product['name'],
          'comment': comment,
          'userId': currentUser.uid,
          'userEmail': currentUser.email ?? 'Usuário Anônimo', // Garantir email
          'timestamp': FieldValue.serverTimestamp(),
        });

        commentController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Comentário enviado!"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print("Erro ao salvar comentário: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao enviar comentário."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]!),
        backgroundColor: const Color.fromARGB(255, 66, 35, 151),
        iconTheme: const IconThemeData(color: Colors.white), // Ícones brancos
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navega para a página do carrinho
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cart),
                ),
              );
            },
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do produto
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product["image"]!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              // Nome do produto
              Text(
                product["name"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Preço do produto
              Text(
                product["price"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              // Descrição do produto (com fallback)
              Text(
                product["description"] ?? "Descrição não disponível.",
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              // Link "Ver Comentários"
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsPage(
                        productName: product["name"]!,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Ver Comentários",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Adicionar Comentário
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText:
                            "Escreva um comentário (máx. 200 caracteres)...",
                        hintStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => addComment(commentController.text),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Botão "Adicionar ao Carrinho"
              ElevatedButton(
                onPressed: () {
                  if (cart.containsKey(product)) {
                    cart[product] = cart[product]! + 1; // Incrementa
                  } else {
                    cart[product] = 1; // Adiciona
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${product["name"]} foi adicionado ao carrinho!'),
                      backgroundColor: const Color.fromARGB(255, 66, 35, 151),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 66, 35, 151),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Adicionar ao Carrinho",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
