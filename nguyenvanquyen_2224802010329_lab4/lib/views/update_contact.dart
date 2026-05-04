import 'package:flutter/material.dart';
import '../controllers/crud_services.dart';

class UpdateContactPage extends StatefulWidget {
  final dynamic doc;

  const UpdateContactPage({super.key, required this.doc});

  @override
  State<UpdateContactPage> createState() => _UpdateContactPageState();
}

class _UpdateContactPageState extends State<UpdateContactPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.doc["name"]);
    phoneController = TextEditingController(text: widget.doc["phone"]);
    emailController = TextEditingController(text: widget.doc["email"]);
  }

  // UPDATE
  void updateContact() async {
    if (_formKey.currentState!.validate()) {
      await CRUDService().updateContact(
        widget.doc.id,
        nameController.text.trim(),
        phoneController.text.trim(),
        emailController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context); // quay về Home ngay
    }
  }

  // DELETE
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc muốn xóa contact này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // đóng dialog

              await CRUDService().deleteContact(widget.doc.id);

              if (!mounted) return;

              Navigator.pop(context); // quay về Home
            },
            child: const Text(
              "Xóa",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
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
        title: const Text("Update Contact"),
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
                  "Edit Contact",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

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

                TextFormField(
                  controller: phoneController,
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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateContact,
                    child: const Text("Update"),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: confirmDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Delete"),
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