import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- DATA MODEL for a single history item ---
class HistoryItem {
  final String title;
  final IconData icon;
  final String summary;
  final List<String> recommendedActions;
  final bool isFinished;

  HistoryItem({
    required this.title,
    required this.icon,
    required this.summary,
    this.recommendedActions = const [],
    this.isFinished = true,
  });
}

// --- HISTORY PAGE WIDGET ---
class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  // --- DUMMY DATA ---
  final List<HistoryItem> historyItems = [
    HistoryItem(
      title: "Starting a Cafe",
      icon: FontAwesomeIcons.mugSaucer,
      summary: "Explored the journey of opening a physical cafe, securing a traditional bank loan for funding.",
      isFinished: true,
      recommendedActions: [
        "Draft a comprehensive business plan.",
        "Compile two years of financial statements.",
        "Improve credit score above 720.",
        "Research local small business loans.",
      ],
    ),
    HistoryItem(
      title: "My First Home Loan",
      icon: FontAwesomeIcons.houseChimney,
      summary: "Simulated the process of applying for a home loan but stopped before choosing an interest rate plan.",
      isFinished: false,
    ),
    HistoryItem(
      title: "Retirement Plan",
      icon: FontAwesomeIcons.solidSun,
      summary: "Calculated the savings needed to retire comfortably by age 65 with an aggressive investment strategy.",
      isFinished: true,
      recommendedActions: [
        "Open a Roth IRA account.",
        "Contribute \$500 monthly.",
        "Review portfolio allocation annually.",
      ],
    ),
    HistoryItem(
      title: "Emergency Fund",
      icon: FontAwesomeIcons.shieldHalved,
      summary: "Established a goal to save 6 months of living expenses.",
      isFinished: true,
      recommendedActions: [
        "Set up automatic transfers to a high-yield savings account.",
        "Reduce non-essential spending by 15%.",
      ],
    ),
    HistoryItem(
      title: "Car Purchase",
      icon: FontAwesomeIcons.car,
      summary: "Compared financing options for buying a new car, including dealership financing vs. a personal loan.",
      isFinished: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'My Scenarios',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        // Using MasonryGridView for the uneven tiles effect
        child: MasonryGridView.builder(
          itemCount: historyItems.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          itemBuilder: (context, index) {
            return _HistoryCard(item: historyItems[index]);
          },
        ),
      ),
    );
  }
}

// --- CUSTOM HISTORY CARD WIDGET ---
class _HistoryCard extends StatelessWidget {
  final HistoryItem item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon and Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FaIcon(item.icon, color: const Color(0xFF0D47A1), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF212529),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Summary Text
          Text(
            item.summary,
            style: const TextStyle(
              color: Color(0xFF495057),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const Divider(height: 24, color: Color(0xFFE9ECEF)),

          // Conditional Content: Recommendations or CTA Button
          if (item.isFinished)
            _buildRecommendations(item.recommendedActions)
          else
            _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildRecommendations(List<String> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended Actions:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        // Create a checklist from the actions list
        for (String action in actions)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("✅ ", style: TextStyle(fontSize: 14)),
                Expanded(
                  child: Text(
                    action,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF495057)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.arrow_forward_ios, size: 14),
        label: const Text('Continue Story'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}