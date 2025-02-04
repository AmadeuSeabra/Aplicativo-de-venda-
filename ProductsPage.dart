import 'package:bike3/ProductDetailPage.dart'; // Importa a página de detalhes do produto
import 'package:bike3/CartPage.dart'; // Importa a página do carrinho
import 'package:bike3/main.dart'; // Importa a página principal (para o LoginPage)
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth para autenticação
import 'package:flutter/material.dart'; // Framework principal do Flutter
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase Messaging para notificações

final FirebaseMessaging _messaging = FirebaseMessaging.instance;

Future<void> subscribeToTopic() async {
  await _messaging.subscribeToTopic('comments');
}

// Mapa global para armazenar os itens do carrinho e suas quantidades
Map<Map<String, String>, int> cart = {};

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de produtos disponíveis na loja
    final List<Map<String, String>> products = [
      {
        "name": "Mountain Bike",
        "price": "R\$ 1,200.00",
        "image": "assets/imagens/Roadbike.jpg",
        "description":
            "Mountain bikes são projetadas para aventuras off-road, ideais para trilhas desafiadoras, subidas íngremes e descidas radicais. Possuem suspensões robustas, pneus largos e quadros resistentes, garantindo conforto e estabilidade em terrenos acidentados."
      },
      {
        "name": "Road Bike",
        "price": "R\$ 2,500.00",
        "image": "assets/imagens/Roadbike1.jpg",
        "description":
            "As bicicletas de estrada são feitas para velocidade e desempenho em asfalto. Seu design aerodinâmico, pneus finos e leves, e quadros de alta performance tornam estas bikes perfeitas para longas distâncias e treinos intensos."
      },
      {
        "name": "Hybrid Bike",
        "price": "R\$ 1,800.00",
        "image": "assets/imagens/HybridBike.jpg",
        "description":
            "As bicicletas híbridas combinam características de mountain bikes e road bikes, oferecendo versatilidade para andar tanto na cidade quanto em trilhas leves. São perfeitas para quem busca mobilidade urbana e lazer."
      },
      {
        "name": "Electric Bike",
        "price": "R\$ 4,000.00",
        "image": "assets/imagens/EletricBike.jpg",
        "description":
            "As bicicletas elétricas oferecem uma maneira prática e ecológica de se locomover, combinando o esforço humano com assistência elétrica. Equipadas com motor e bateria recarregável, são ideais para trajetos urbanos e viagens mais longas."
      },
    ];

    // Obtém o usuário atualmente logado
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        // Fundo com gradiente
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
        child: SafeArea(
          child: Column(
            children: [
              // Cabeçalho da página
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título da página
                        const Text(
                          "BIKETEEN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Exibe o email do usuário logado, se disponível
                        if (user != null)
                          Text(
                            "Bem-vindo, ${user.email ?? "Usuário"}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                    // Botões de carrinho e logout
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.white),
                          onPressed: () {
                            // Navega para a página do carrinho
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartPage(cartItems: cart)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () async {
                            // Faz logout do usuário
                            await FirebaseAuth.instance.signOut();
                            // Navega para a página de login
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Lista de produtos em grade
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  // Configura o layout da grade
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Duas colunas
                    crossAxisSpacing: 10, // Espaçamento horizontal
                    mainAxisSpacing: 10, // Espaçamento vertical
                    childAspectRatio: 0.8, // Proporção dos itens
                  ),
                  itemCount: products.length, // Número de produtos
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        // Navega para a página de detalhes do produto ao clicar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: Container(
                        // Estilo do cartão de produto
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagem do produto com errorBuilder
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.asset(
                                product["image"]!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 120,
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Text(
                                        "Erro ao carregar imagem",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Nome e preço do produto
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product["name"]!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product["price"]!,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
