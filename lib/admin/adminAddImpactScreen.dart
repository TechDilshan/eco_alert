import 'package:flutter/material.dart';

class AdminAddImpactScreen extends StatefulWidget {
  const AdminAddImpactScreen({super.key});

  @override
  _AddImpactScreenState createState() => _AddImpactScreenState();
}

class _AddImpactScreenState extends State<AdminAddImpactScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Impact Details'),
        backgroundColor: const Color.fromARGB(255, 37, 108, 166), // Blue theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Impact Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an impact title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Impact Description',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an impact description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Handle form submission
                      final title = _titleController.text;
                      final description = _descriptionController.text;

                      // For now, just show a Snackbar with the entered details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Impact Added: $title - $description'),
                        ),
                      );

                      // Clear the form
                      _titleController.clear();
                      _descriptionController.clear();
                    }
                  },
                  child: const Text('Add Impact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 37, 108, 166), // Blue theme color
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
