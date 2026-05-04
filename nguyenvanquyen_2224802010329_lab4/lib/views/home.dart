import 'package:flutter/material.dart';
import '../controllers/crud_services.dart';
import '../controllers/auth_services.dart';
import 'update_contact.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Contacts"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: CRUDService().getContacts(),
          builder: (context, snapshot) {
            // LOADING
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ERROR
            if (snapshot.hasError) {
              return const Center(child: Text("Có lỗi xảy ra"));
            }

            var docs = snapshot.data!.docs;

            // EMPTY
            if (docs.isEmpty) {
              return const Center(
                child: Text(
                  "Chưa có contact nào",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            // LIST
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var data = docs[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        data["name"][0].toUpperCase(),
                      ),
                    ),

                    title: Text(
                      data["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data["phone"]),
                        Text(data["email"]),
                      ],
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateContactPage(doc: data),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),

      // FLOAT BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}