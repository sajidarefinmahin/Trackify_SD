import 'package:flutter/material.dart';
import 'package:trackify/pages/dashboard_page.dart';
import 'package:trackify/pages/transaction_page.dart';
import 'package:trackify/models/transactions.dart';

import '../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();

  void _navigateToTransactionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FFFC),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _firestoreService.getTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!;

          return DashboardPage(
            onAddPressed: _navigateToTransactionPage,
            allTransactions: transactions,
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToTransactionPage,
        backgroundColor: Color(0xFF0A2342),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
