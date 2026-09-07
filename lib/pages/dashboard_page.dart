import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackify/widgets/balance_card.dart';
import 'package:trackify/widgets/dashboard_header.dart';
import 'package:trackify/widgets/recent_transactions_card.dart';
import 'package:trackify/models/transactions.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback onAddPressed;
  final List<TransactionModel> allTransactions;

  const DashboardPage({super.key, required this.onAddPressed, required this.allTransactions});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final List<TransactionModel> sortedTransactions = List.from(widget.allTransactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    final List<TransactionModel> limitedRecentTransactions = sortedTransactions.take(5).toList();

    final DateTime now = DateTime.now();
    double totalExpense = 0.0;

    for (var tx in widget.allTransactions) {
      if (tx.type == TransactionType.expense &&
          tx.date.month == now.month &&
          tx.date.year == now.year) {
        totalExpense += tx.amount;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            const SizedBox(height: 15),

            DashboardHeader(
              name: user?.displayName ?? "User",
              onProfilePressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                          ),
                          const SizedBox(width: 15),
                          const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
                      content: const Text("Are you sure you want to log out?", style: TextStyle(color: Colors.black54)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await FirebaseAuth.instance.signOut();
                          },
                          child: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 15),

            BalanceCard(
              onAddPressed: widget.onAddPressed,
              totalExpense: totalExpense,
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 15),

            limitedRecentTransactions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                            child: Icon(Icons.receipt_long, color: Colors.grey[400], size: 30),
                          ),
                          const SizedBox(height: 12),
                          Text("No transactions yet", style: TextStyle(color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: limitedRecentTransactions.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      return RecentTransactionsCard(transaction: limitedRecentTransactions[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
