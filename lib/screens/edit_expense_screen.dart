import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../managers/expense_manager.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final Function(Expense)? onUpdate;

  const EditExpenseScreen({super.key, required this.expense, this.onUpdate,});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;

  final List<String> categories = [
    'Material',
    'Marketing',
    'Packaging',
    'Transportasi',
    'Konsumsi',
    'Lainnya',
  ];

  

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _descriptionController =
        TextEditingController(text: widget.expense.description);
    _selectedCategory = widget.expense.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengeluaran'), backgroundColor: const Color.fromARGB(255, 243, 33, 180),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Masukkan angka valid'
                        : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedCategory = value!;
                }),
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 243, 33, 180), 
                  foregroundColor: Colors.white, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedExpense = Expense(
                      id: widget.expense.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      amount: double.parse(_amountController.text),
                      category: _selectedCategory,
                      date: widget.expense.date,
                      username: widget.expense.username,
                    );

                    ExpenseManager.updateExpense(updatedExpense);

                    if (widget.onUpdate != null) {
                      widget.onUpdate!(updatedExpense);
                    }

                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan Perubahan', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins',
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
