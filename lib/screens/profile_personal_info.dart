import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // Import the new package

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();

  // State variables remain the same
  String? name = "Juan Dela Cruz";
  String? age;
  String? incomeSource;
  String? monthlyIncome;
  String? monthlyExpenses;
  bool hasPension = false;
  bool hasInsurance = false;
  bool hasInvestments = false;
  final List<TextEditingController> _pensionControllers = [];
  final List<TextEditingController> _insuranceControllers = [];
  final List<TextEditingController> _investmentControllers = [];
  List<String> pensions = [];
  List<String> insurances = [];
  List<String> investments = [];
  List<String> financialGoals = [];
  final List<String> availableGoals = [
    "Build Emergency Fund",
    "Pay Off Debt",
    "Save for a House",
    "Save for a Car",
    "Invest for Growth",
    "Plan for Retirement",
    "Fund a Vacation",
    "Start a Business",
    "Education/Upskilling",
    "Home Renovation",
  ];
  static const Color _primaryRed = Color(0xFFA42A25);

  @override
  void dispose() {
    for (var controller in _pensionControllers) {
      controller.dispose();
    }
    for (var controller in _insuranceControllers) {
      controller.dispose();
    }
    for (var controller in _investmentControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information"),
        backgroundColor: Colors.white,
        foregroundColor: _primaryRed,
        elevation: 0.5,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildAssetsSection(),
              const SizedBox(height: 24),
              _buildGoalsSection(),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryRed,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveForm,
                child: const Text("Save Information", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      pensions = _pensionControllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();
      insurances = _insuranceControllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();
      investments = _investmentControllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();
      debugPrint("Pensions Saved: $pensions");
      debugPrint("Insurances Saved: $insurances");
      debugPrint("Investments Saved: $investments");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Personal Info Saved!")),
      );
      Navigator.of(context).pop();
    }
  }

  Widget _buildLabeledTextField({
    required String label,
    String? initialValue,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
  }) {
    const Color labelColor = Color(0xFF1E5631);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: labelColor, fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryRed, width: 2.0)),
            ),
            keyboardType: keyboardType,
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabeledTextField(label: "Name", initialValue: name, onSaved: (val) => name = val),
        _buildLabeledTextField(label: "Age", keyboardType: TextInputType.number, onSaved: (val) => age = val),
        _buildLabeledTextField(label: "Source of Income", onSaved: (val) => incomeSource = val),
        _buildLabeledTextField(label: "Monthly Income", keyboardType: TextInputType.number, onSaved: (val) => monthlyIncome = val),
        _buildLabeledTextField(label: "Monthly Expenses", keyboardType: TextInputType.number, onSaved: (val) => monthlyExpenses = val),
      ],
    );
  }

  Widget _buildAssetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Do you have a Pension Plan?"),
          value: hasPension,
          onChanged: (val) => setState(() {
            hasPension = val;
            if (!val) _pensionControllers.clear();
          }),
          activeColor: _primaryRed,
        ),
        if (hasPension) _buildDynamicTextFieldList(title: "Pension", controllers: _pensionControllers),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Do you have Active Insurance?"),
          value: hasInsurance,
          onChanged: (val) => setState(() {
            hasInsurance = val;
            if (!val) _insuranceControllers.clear();
          }),
          activeColor: _primaryRed,
        ),
        if (hasInsurance) _buildDynamicTextFieldList(title: "Insurance", controllers: _insuranceControllers),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text("Do you have Investments?"),
          value: hasInvestments,
          onChanged: (val) => setState(() {
            hasInvestments = val;
            if (!val) _investmentControllers.clear();
          }),
          activeColor: _primaryRed,
        ),
        if (hasInvestments) _buildDynamicTextFieldList(title: "Investment", controllers: _investmentControllers),
      ],
    );
  }

  // --- AESTHETIC UPDATE: This widget is now redesigned ---
  Widget _buildDynamicTextFieldList({
    required String title,
    required List<TextEditingController> controllers,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // List of existing text fields
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          labelText: '$title #${index + 1}',
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade400)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryRed, width: 2.0)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.grey.shade600),
                      onPressed: () {
                        setState(() {
                          controllers[index].dispose();
                          controllers.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          // The new "Add" button with a dashed border
          DottedBorder(
            color: Colors.grey.withOpacity(0.0),
            strokeWidth: 1.5,
            dashPattern: const [6, 5],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  controllers.add(TextEditingController());
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: _primaryRed.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline, color: _primaryRed),
                      const SizedBox(width: 8),
                      Text(
                        "Add $title",
                        style: const TextStyle(color: _primaryRed, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    const Color labelColor = Color(0xFF1E5631);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Financial Goals", style: TextStyle(color: labelColor, fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
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
              selectedColor: _primaryRed,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
            );
          }).toList(),
        ),
      ],
    );
  }
}