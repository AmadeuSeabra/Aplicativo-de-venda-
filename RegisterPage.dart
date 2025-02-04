import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Biblioteca para autenticação com Firebase
import 'package:cloud_firestore/cloud_firestore.dart'; // Biblioteca para integração com Firestore

// Define a classe RegisterPage como um StatefulWidget
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// Classe responsável pelo estado da página de registro
class _RegisterPageState extends State<RegisterPage> {
  // Controladores para capturar entrada do usuário nos campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instância do Firebase Auth para autenticação
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mensagem de erro exibida ao usuário, se houver
  String? _errorMessage;

  // Método para realizar o registro de um novo usuário
  Future<void> _register() async {
    try {
      // Registra o usuário com email e senha
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Salva informações adicionais do usuário no Firestore (opcional)
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Retorna à tela de login após o registro bem-sucedido
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Exibe mensagem de erro, se houver falha no registro
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Container com um gradiente de fundo
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 106, 33, 139), // Cor inicial do gradiente
              Color.fromARGB(255, 82, 25, 240), // Cor final do gradiente
            ],
            begin: Alignment.topLeft, // Início do gradiente
            end: Alignment.bottomRight, // Fim do gradiente
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0), // Espaçamento interno
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza o conteúdo
              children: [
                // Título principal
                const Text(
                  "Create an Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8), // Espaçamento
                // Subtítulo
                const Text(
                  "Sign up to start your journey",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40), // Espaçamento
                // Campo de entrada para o nome
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: "Name",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espaçamento
                // Campo de entrada para o email
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
                const SizedBox(height: 20), // Espaçamento
                // Campo de entrada para a senha
                TextField(
                  controller: _passwordController,
                  obscureText: true, // Esconde o texto
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
                const SizedBox(height: 20), // Espaçamento
                // Exibe mensagem de erro, se houver
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 221, 56, 44), // Cor do texto de erro
                    ),
                  ),
                const SizedBox(height: 20), // Espaçamento
                // Botão de cadastro
                ElevatedButton(
                  onPressed: _register, // Chama o método de registro
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
                    "Register",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20), // Espaçamento
                // Botão para voltar à tela de login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Retorna para a página anterior
                  },
                  child: const Text(
                    "Already have an account? Login here",
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
