import 'package:flutter/material.dart';

import '../models/transactions.dart';
import '../services/firestore_service.dart';

class TransactionPage extends StatefulWidget {
  final TransactionModel? transactionToEdit;

  const TransactionPage({super.key, this.transactionToEdit});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FocusNode _amountFocusNode = FocusNode();

  String _selectedType = 'Expense';
  String? _selectedCategory;
  DateTime? _selectedDate = DateTime.now();
  String _selectedWallet = 'Cash';

  bool _isSaving = false;

  final List<String> _wallets = ['Cash', 'bKash', 'Bank', 'Metro Card'];

  final List<String> _incomeCategories = [
    'Salary', 'Business', 'Investments', 'Gifts', 'Rental', 'Other',
  ];
  final List<String> _expenseCategories = [
    'Food', 'Housing', 'Transport', 'Health', 'Travel', 'Shopping',
    'Entertainment', 'Education', 'Finance', 'Miscellaneous',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.transactionToEdit != null) {
      final tx = widget.transactionToEdit!;
      _titleController.text = tx.title;
      _amountController.text = tx.amount.toString();

      if (tx.type == TransactionType.income) {
        _selectedType = 'Income';
      } else {
        _selectedType = 'Expense';
      }

      _selectedCategory = tx.category;
      _selectedDate = tx.date;
      _selectedWallet = tx.wallet.isNotEmpty ? tx.wallet : 'Cash';
    }
  }

  IconData _getWalletIcon(String walletName) {
    if (walletName == 'Cash') return Icons.money_rounded;
    if (walletName == 'Bank') return Icons.account_balance_rounded;
    if (walletName.contains('Card') || walletName.contains('Pass')) return Icons.directions_transit_rounded;
    return Icons.phone_android_rounded;
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0A2342), onPrimary: Colors.white, onSurface: Colors.black87),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) setState(() => _selectedDate = value);
    });
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final firestoreService = FirestoreService();

      TransactionType tType = _selectedType == 'Income'
          ? TransactionType.income
          : TransactionType.expense;

      TransactionModel transaction = TransactionModel(
        id: widget.transactionToEdit?.id ?? '',
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        date: _selectedDate!,
        category: _selectedCategory!,
        type: tType,
        wallet: _selectedWallet,
        guiltValue: 0.0,
      );

      if (widget.transactionToEdit != null) {
        await firestoreService.reverseWalletBalance(widget.transactionToEdit!);
        await firestoreService.updateTransaction(transaction);
        await firestoreService.updateWalletBalance(_selectedWallet, transaction.amount, tType);
      } else {
        await firestoreService.addTransaction(transaction);
        await firestoreService.updateWalletBalance(_selectedWallet, transaction.amount, tType);
      }

      if (mounted) Navigator.pop(context);
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date"), behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Widget _buildWalletSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, bottom: 10),
          child: Text("Wallet", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: _wallets.map((wallet) {
              bool isSelected = _selectedWallet == wallet;
              return GestureDetector(
                onTap: () => setState(() => _selectedWallet = wallet),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0A2342) : const Color(0xFFF4F7F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(_getWalletIcon(wallet), size: 18, color: isSelected ? Colors.white : Colors.grey[500]),
                      const SizedBox(width: 8),
                      Text(
                        wallet,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.transactionToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A2342),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _amountFocusNode.requestFocus(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  children: [
                    const Text("Amount", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 10),
                    IntrinsicWidth(
                      child: TextFormField(
                        focusNode: _amountFocusNode,
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 55, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -2),
                        decoration: const InputDecoration(
                          prefixText: "৳ ",
                          prefixStyle: TextStyle(fontSize: 55, fontWeight: FontWeight.w800, color: Colors.white70),
                          border: InputBorder.none,
                          hintText: "0",
                          hintStyle: TextStyle(color: Colors.white38),
                        ),
                        validator: (v) => v!.isEmpty ? "Enter amount" : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: const Color(0xFFF4F7F6), borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Expanded(child: _buildTypeToggle('Expense')),
                              Expanded(child: _buildTypeToggle('Income')),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildWalletSelector(),

                      const SizedBox(height: 25),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            _buildModernInput(
                              icon: Icons.title,
                              hint: "Title",
                              child: TextFormField(
                                controller: _titleController,
                                decoration: const InputDecoration(border: InputBorder.none, hintText: "Title"),
                                validator: (v) => v!.isEmpty ? "Enter a title" : null,
                              ),
                            ),
                            const SizedBox(height: 15),

                            _buildModernInput(
                              icon: Icons.folder_open,
                              hint: "Category",
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                items: (_selectedType == 'Income' ? _incomeCategories : _expenseCategories)
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (val) => setState(() => _selectedCategory = val),
                                decoration: const InputDecoration(border: InputBorder.none, hintText: "Select Category"),
                                validator: (val) => val == null ? "Select a category" : null,
                              ),
                            ),
                            const SizedBox(height: 15),

                            _buildModernInput(
                              icon: Icons.calendar_today_outlined,
                              hint: "Date",
                              child: GestureDetector(
                                onTap: _showDatePicker,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    _selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : "Select Date",
                                    style: TextStyle(fontSize: 16, color: _selectedDate != null ? Colors.black87 : Colors.grey[600]),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isSaving
                                    ? null
                                    : () async {
                                        setState(() => _isSaving = true);
                                        try {
                                          await _saveTransaction();
                                        } finally {
                                          if (mounted) setState(() => _isSaving = false);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: const Color(0xFF0A2342).withOpacity(0.7),
                                  backgroundColor: const Color(0xFF0A2342),
                                  elevation: 5,
                                  shadowColor: const Color(0xFF0A2342).withOpacity(0.4),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 24, height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                      )
                                    : Text(
                                        isEditing ? "Update Transaction" : "Save Transaction",
                                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeToggle(String type) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A2342) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF0A2342).withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 2))]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[500],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildModernInput({required IconData icon, required String hint, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(color: const Color(0xFFF4F7F6), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[500], size: 22),
          const SizedBox(width: 15),
          Expanded(child: child),
        ],
      ),
    );
  }
}
