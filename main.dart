import 'package:bike3/ProductsPage.dart';
import 'package:bike3/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa a funcionalidade de autenticação do Firebase
import 'firebase_options.dart'; // Importa as opções de configuração do Firebase geradas automaticamente
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _messaging = FirebaseMessaging.instance;

Future<void> subscribeToTopic() async {
  await _messaging.subscribeToTopic('comments');
}

// Inicializa o aplicativo e o Firebase
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que o Flutter esteja inicializado antes de usar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Configurações específicas da plataforma
  );
  runApp(const MyApp()); // Inicia o aplicativo
}

// Widget principal da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      title: 'Login App', // Título do aplicativo
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple), // Define um tema de cores
        useMaterial3: true, // Ativa o Material 3 para o design
      ),
      home: const LoginPage(), // Define a página inicial como a página de login
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Estado da página de login
class _LoginPageState extends State<LoginPage> {
  // Controladores para os campos de email e senha
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mensagem de erro para exibição ao usuário
  String? _errorMessage;

  // Método para realizar o login
  Future<void> _login() async {
    try {
      // Tenta autenticar o usuário com email e senha
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Se o login for bem-sucedido, navega para a página de produtos
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductsPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Exibe mensagem de erro, se houver
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 106, 33, 139),
              Color.fromARGB(255, 82, 25, 240)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título e subtítulo
                const Text(
                  "Welcome BKT!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Login to access your account",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),
                // Campo de entrada para email
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: "Email",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de entrada para senha
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Exibe mensagem de erro, se houver
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 221, 56, 44)),
                  ),
                const SizedBox(height: 20),
                // Botão de login
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 35, 151),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 40.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                // Adicione este botão abaixo do botão de Login
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register here",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
