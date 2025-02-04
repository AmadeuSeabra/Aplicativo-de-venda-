import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importação da biblioteca intl

class CommentsPage extends StatelessWidget {
  final String productName;

  const CommentsPage({super.key, required this.productName});

  // Função para formatar a data de comentário
  String formatDate(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentários'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection('comments')
                .where('productName', isEqualTo: productName)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar comentários.",
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Nenhum comentário ainda.",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final comments = snapshot.data!.docs;

              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final commentData =
                      comments[index].data() as Map<String, dynamic>;
                  final timestamp = commentData['timestamp'] as Timestamp?;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        commentData['userEmail'] ?? "Usuário Anônimo",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commentData['comment'] ?? "Comentário vazio",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          if (timestamp != null)
                            Text(
                              formatDate(timestamp),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
