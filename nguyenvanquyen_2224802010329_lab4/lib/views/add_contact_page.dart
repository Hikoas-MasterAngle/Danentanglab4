import 'package:flutter/material.dart';
import '../controllers/crud_services.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // ADD FUNCTION
  void addContact() async {
    if (_formKey.currentState!.validate()) {
      await CRUDService().addContact(
        nameController.text.trim(),
        phoneController.text.trim(),
        emailController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context); // quay về Home ngay
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "New Contact",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // NAME
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Tên không được để trống" : null,
                ),

                const SizedBox(height: 15),

                // PHONE
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "SĐT không được để trống";
                    }
                    if (value.length < 9) {
                      return "SĐT không hợp lệ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                // EMAIL
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email không được để trống";
                    }
                    if (!value.contains("@")) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // ADD BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: addContact,
                    child: const Text("Add Contact"),
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