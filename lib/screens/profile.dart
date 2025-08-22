import 'package:flutter/material.dart';

// --- ACCOUNT PAGE (Profile) ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/logo.png"), // replace with your logo
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/profile.jpg"), // dummy profile
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Andrew Ainsley",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("andrew.ainsley@yourdomain.com",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Discover Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.star, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Discover BPI products\nChoose what suits your lifestyle",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("General", style: TextStyle(color: Colors.grey)),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Personal Info"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PersonalInfoPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text("Language"),
              trailing: const Text("English (US)"),
            ),

            const SizedBox(height: 16),
            const Text("About", style: TextStyle(color: Colors.grey)),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help Center"),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Privacy Policy"),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About ChattyAI"),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PERSONAL INFO PAGE ---
class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  String? age;
  String? incomeSource;
  String? monthlyIncome;
  String? monthlyExpenses;

  bool hasPension = false;
  List<String> pensions = [];

  bool hasInsurance = false;
  List<String> insurances = [];

  bool hasInvestments = false;
  List<String> investments = [];

  List<String> financialGoals = [];
  final List<String> availableGoals = [
    "Save More",
    "Retirement",
    "Travel",
    "Emergency Fund",
    "Pay Debt"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Information")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Age
              TextFormField(
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                onSaved: (val) => age = val,
              ),
              // Source of Income
              TextFormField(
                decoration: const InputDecoration(labelText: "Source of Income"),
                onSaved: (val) => incomeSource = val,
              ),
              // Monthly Income
              TextFormField(
                decoration: const InputDecoration(labelText: "Monthly Income"),
                keyboardType: TextInputType.number,
                onSaved: (val) => monthlyIncome = val,
              ),
              // Monthly Expenses
              TextFormField(
                decoration: const InputDecoration(labelText: "Monthly Expenses"),
                keyboardType: TextInputType.number,
                onSaved: (val) => monthlyExpenses = val,
              ),
              const SizedBox(height: 20),

              // Pension
              SwitchListTile(
                title: const Text("Has Pension?"),
                value: hasPension,
                onChanged: (val) => setState(() => hasPension = val),
              ),
              if (hasPension)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "List of Pensions (comma separated)",
                  ),
                  onSaved: (val) =>
                      pensions = val?.split(",").map((e) => e.trim()).toList() ??
                          [],
                ),

              // Insurance
              SwitchListTile(
                title: const Text("Has Insurance?"),
                value: hasInsurance,
                onChanged: (val) => setState(() => hasInsurance = val),
              ),
              if (hasInsurance)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "List of Active Insurance (comma separated)",
                  ),
                  onSaved: (val) =>
                      insurances = val?.split(",").map((e) => e.trim()).toList() ??
                          [],
                ),

              // Investments
              SwitchListTile(
                title: const Text("Has Investments?"),
                value: hasInvestments,
                onChanged: (val) => setState(() => hasInvestments = val),
              ),
              if (hasInvestments)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "List of Active Investments (comma separated)",
                  ),
                  onSaved: (val) =>
                      investments =
                          val?.split(",").map((e) => e.trim()).toList() ?? [],
                ),

              const SizedBox(height: 20),
              const Text("Financial Goals", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: availableGoals.map((goal) {
                  final selected = financialGoals.contains(goal);
                  return FilterChip(
                    label: Text(goal),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          financialGoals.add(goal);
                        } else {
                          financialGoals.remove(goal);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: Save to database or provider
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Personal Info Saved!")),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}