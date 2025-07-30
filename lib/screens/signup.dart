import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();

  // State variables for form fields
  String? _selectedIncomeSource;
  final List<String> _financialGoals = [
    'Buy a Home',
    'Save for Retirement',
    'Travel Fund',
    'Start a Business',
    'Emergency Fund',
    'Education'
  ];
  final Set<String> _selectedGoals = {};
  bool _isBpiClient = false;

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('MMMM d, y').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF003C43), // Your app's dark teal
            Color(0xFF135D66), // Your app's lighter teal
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Personalize Your Profile'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle skip action -> navigate to home screen
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Telling us more helps create a financial story just for you.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 32.0),

                // --- Name Field ---
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 20.0),

                // --- Date of Birth Field ---
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                ),
                const SizedBox(height: 20.0),

                // --- Source of Income Field ---
                DropdownButtonFormField<String>(
                  value: _selectedIncomeSource,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedIncomeSource = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Primary Source of Income',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  items: <String>['Employment', 'Business', 'Freelance', 'Investments', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),

                // --- Income and Expenses ---
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Monthly Income',
                          prefixIcon: Icon(Icons.attach_money_outlined),
                          prefixText: '₱ ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Monthly Expenses',
                          prefixIcon: Icon(Icons.money_off_outlined),
                          prefixText: '₱ ',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),

                // --- Financial Goals ---
                const Text(
                  'What are your financial goals?',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _financialGoals.map((goal) {
                    final bool isSelected = _selectedGoals.contains(goal);
                    return ChoiceChip(
                      label: Text(goal),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedGoals.add(goal);
                          } else {
                            _selectedGoals.remove(goal);
                          }
                        });
                      },
                      backgroundColor: const Color(0xFF135D66),
                      selectedColor: const Color(0xFF77B0AA),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32.0),

                // --- BPI User Toggle ---
                SwitchListTile(
                  title: const Text(
                    'Are you a BPI client?',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'This can help us suggest relevant products.',
                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                  ),
                  value: _isBpiClient,
                  onChanged: (bool value) {
                    setState(() {
                      _isBpiClient = value;
                    });
                  },
                  activeColor: const Color(0xFF77B0AA),
                  tileColor: const Color(0xFF135D66).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                const SizedBox(height: 40.0),

                // --- Finish Button ---
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE3FEF7),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Finish Setup',
                    style: TextStyle(
                      color: Color(0xFF003C43),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}