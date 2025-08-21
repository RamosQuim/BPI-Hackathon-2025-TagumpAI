import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// --- PROFILE PAGE WIDGET ---
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // --- DUMMY USER DATA (This would come from your state management/backend) ---
  String fullName = "Alex Doe";
  String email = "alex.doe@email.com";
  String dob = "August 15, 1995";
  String incomeSource = "Employment";
  double monthlyIncome = 50000.00;
  double monthlyExpenses = 35000.00;
  final Set<String> _financialGoals = {
    'Buy a Home',
    'Save for Retirement',
    'Emergency Fund',
    'Run a Small Coffee Shop',
  };

  // --- EDIT DIALOG HANDLER ---
  Future<void> _showEditDialog(
    BuildContext context,
    String field,
    double currentValue,
  ) async {
    final controller = TextEditingController(
      text: currentValue.toStringAsFixed(0),
    );
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: '₱ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    final newValue = double.parse(controller.text);
                    if (field == 'Monthly Income') {
                      monthlyIncome = newValue;
                    } else {
                      monthlyExpenses = newValue;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void logOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.logout();

      // navigate to the login screen or home page after logout
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildSection(
              title: "Personal Information",
              child: Column(
                children: [
                  _ProfileInfoTile(
                    icon: FontAwesomeIcons.user,
                    label: "Full Name",
                    value: fullName,
                  ),
                  _ProfileInfoTile(
                    icon: FontAwesomeIcons.cakeCandles,
                    label: "Date of Birth",
                    value: dob,
                  ),
                  _ProfileInfoTile(
                    icon: FontAwesomeIcons.briefcase,
                    label: "Income Source",
                    value: incomeSource,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Financial Details",
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _FinancialDetailCard(
                          title: "Monthly Income",
                          icon: FontAwesomeIcons.wallet,
                          value: monthlyIncome,
                          color: Colors.green,
                          onEdit: () => _showEditDialog(
                            context,
                            "Monthly Income",
                            monthlyIncome,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _FinancialDetailCard(
                          title: "Monthly Expenses",
                          icon: FontAwesomeIcons.receipt,
                          value: monthlyExpenses,
                          color: Colors.red,
                          onEdit: () => _showEditDialog(
                            context,
                            "Monthly Expenses",
                            monthlyExpenses,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildWarningNote(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: "Financial Goals",
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _financialGoals
                    .map(
                      (goal) => Chip(
                        label: Text(goal),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: InkWell(
                onTap: () => logOut(),
                child: DefaultTextStyle(
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      color: Color(0xFF494949),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Log out'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER BUILDER WIDGETS ---

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF0D47A1),
              child: Text(
                "A",
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Color(0xFF0D47A1),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          fullName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF495057),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildWarningNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.amber),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Changes to your income or expenses will affect future chatbot recommendations.',
              style: TextStyle(height: 1.4, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM WIDGETS ---

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          // Change the label's color here
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(
                0xFF495057,
              ), // <-- ADDED: A slightly softer black for the label
            ),
          ),
          const Spacer(),
          // Change the value's color here
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(
                0xFF0D47A1,
              ), // <-- ADDED: Using your app's primary blue for the value
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialDetailCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double value;
  final Color color;
  final VoidCallback onEdit;

  const _FinancialDetailCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.color,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_PH', symbol: '₱');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Text(
          currencyFormat.format(value),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 30,
          child: TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
      ],
    );
  }
}
