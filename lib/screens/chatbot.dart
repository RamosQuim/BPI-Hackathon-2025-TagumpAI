import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

// --- DATA MODELS ---
class ChatMessage {
  final String text;
  final MessageSender sender;
  final MessageType type;
  final String? title;
  final IconData? icon;
  final List<String>? choices;
  final Map<String, double>? graphData;

  ChatMessage({
    required this.text,
    required this.sender,
    this.type = MessageType.text,
    this.title,
    this.icon,
    this.choices,
    this.graphData,
  });
}

enum MessageSender { user, ai }
enum MessageType { text, story, graph, recommendation }


// --- MAIN PAGE WIDGET ---
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _textController = TextEditingController();

  // A longer, story-based conversation with choices and a final recommendation.
  final List<ChatMessage> _messages = [
    ChatMessage(
        sender: MessageSender.ai,
        text: "Welcome back, Alex. Let's continue building your financial future. What story shall we write today?",
        type: MessageType.story,
        title: "Choose Your Adventure",
        icon: FontAwesomeIcons.bookOpen,
        choices: ["Plan for retirement", "Start a business", "Save for a big purchase"]
    ),
    ChatMessage(
      sender: MessageSender.user,
      text: "Let's explore starting a business.",
    ),
    ChatMessage(
        sender: MessageSender.ai,
        text: "An exciting chapter! Starting a business is a journey of bold decisions. To begin, what kind of venture are you dreaming of? Your choice will determine the startup capital we need to plan for.",
        type: MessageType.story,
        title: "The Entrepreneur's Dream",
        icon: FontAwesomeIcons.lightbulb,
        choices: ["A low-cost online shop", "A physical cafe"]
    ),
    ChatMessage(
      sender: MessageSender.user,
      text: "I'll choose the physical cafe.",
    ),
    ChatMessage(
        sender: MessageSender.ai,
        type: MessageType.graph,
        title: "Cafe Startup Costs Breakdown",
        icon: FontAwesomeIcons.chartPie,
        text: "A bold choice! A cafe requires significant upfront investment. Here is a sample breakdown of initial costs we need to account for. This illustrates why securing the right funding is critical.",
        graphData: {
          'Rent Deposit': 6000,
          'Renovation': 8000,
          'Equipment': 12000,
          'Licenses': 2000,
          'Inventory': 4000,
        }
    ),
    ChatMessage(
        sender: MessageSender.ai,
        text: "To cover these costs, you'll need funding. We can explore two common paths: a traditional bank loan with lower interest but stricter rules, or a flexible online lender with higher interest. Which path feels right for your story?",
        type: MessageType.story,
        title: "The Crossroads of Funding",
        icon: FontAwesomeIcons.codeBranch,
        choices: ["Traditional bank loan", "Flexible online lender"]
    ),
    ChatMessage(
      sender: MessageSender.user,
      text: "I'll go with the traditional bank loan.",
    ),
    ChatMessage(
        sender: MessageSender.ai,
        type: MessageType.recommendation,
        title: "Your Recommended Action Plan",
        icon: FontAwesomeIcons.solidFlag,
        text: "A wise decision. Prioritizing a lower interest rate sets a strong financial foundation for your cafe. To secure a traditional bank loan, here is your recommended course of action:",
        choices: [
          "1. Draft a comprehensive business plan.",
          "2. Compile at least two years of financial statements.",
          "3. Aim to improve your personal credit score above 720.",
          "4. Research local banks that specialize in small business loans."
        ]
    )
  ];

  void _handleSendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(sender: MessageSender.user, text: _textController.text));
      });
      _textController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF495057), size: 30),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'AgapAI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF212529)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF495057)),
            tooltip: 'Restart Story',
            onPressed: () {},
          ),
        ],
      ),
      drawer: const _AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message.sender == MessageSender.user) {
                  return _UserMessageBubble(message: message);
                }
                // AI messages are now all cards
                return _VisualCard(message: message);
              },
            ),
          ),
          _ChatInputField(
            controller: _textController,
            onSend: _handleSendMessage,
          ),
        ],
      ),
    );
  }
}

// --- WIDGETS (Unchanged from previous version, but shown for completeness) ---

class _VisualCard extends StatelessWidget {
  final ChatMessage message;
  const _VisualCard({required this.message});

  @override
  Widget build(BuildContext context) {
    // Recommendation card gets a special border
    final bool isRecommendation = message.type == MessageType.recommendation;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isRecommendation ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommendation ? Colors.blue.shade300 : Colors.grey.shade200,
          width: isRecommendation ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(message.icon, color: const Color(0xFF0D47A1), size: 20),
              const SizedBox(width: 12),
              Text(
                message.title ?? "A Message from AgapAI",
                style: const TextStyle(
                  color: Color(0xFF212529),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message.text,
            style: const TextStyle(
              color: Color(0xFF495057),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          if (message.type == MessageType.graph && message.graphData != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: _SavingsBarChart(data: message.graphData!),
            ),
          ],
          if (message.choices != null) ...[
            const SizedBox(height: 16),
            // Use different styling for recommendation checklists vs. story choices
            isRecommendation
                ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: message.choices!.map((choice) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("✅  $choice", style: const TextStyle(fontSize: 15, color: Color(0xFF495057), height: 1.4)),
                )).toList()
            )
                : Wrap(
              spacing: 12.0,
              children: message.choices!.map((choice) => ActionChip(
                  label: Text(choice),
                  onPressed: () {},
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w600)
              )).toList(),
            )
          ]
        ],
      ),
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _UserMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, height: 1.4),
        ),
      ),
    );
  }
}

class _ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputField({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Select a choice or type here...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: Color(0xFF0D47A1)),
              onPressed: onSend,
            ),
          ],
        ),
      ),
    );
  }
}

// --- DRAWER & CHART ---

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Alex Doe", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("alex.doe@email.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text("A", style: TextStyle(fontSize: 40.0, color: Color(0xFF0D47A1))),
            ),
            decoration: BoxDecoration(color: Color(0xFF0D47A1)),
          ),
          ListTile(leading: const Icon(Icons.insights), title: const Text('Dashboard'), onTap: () {}),
          ListTile(leading: const Icon(Icons.history), title: const Text('My Scenarios'), onTap: () {}),
          ListTile(leading: const Icon(Icons.account_balance_wallet), title: const Text('Accounts'), onTap: () {}),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () {}),
        ],
      ),
    );
  }
}

class _SavingsBarChart extends StatelessWidget {
  final Map<String, double> data;
  const _SavingsBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final barGroups = <BarChartGroupData>[];
    int i = 0;
    for (final entry in data.entries) {
      barGroups.add(
        BarChartGroupData(
          x: i++,
          barRods: [
            BarChartRodData(
              toY: entry.value,
              color: Colors.blue.shade300,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.values.reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final entry = data.entries.elementAt(groupIndex);
              return BarTooltipItem(
                '${entry.key}\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '\$${rod.toY.round()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    data.keys.elementAt(value.toInt()),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        barGroups: barGroups,
      ),
    );
  }
}