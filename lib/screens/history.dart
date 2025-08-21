import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scenarios = [
      {
        "title": "Starting a Cafe",
        "desc":
            "Plan your budget, equipment, and daily expenses to build a sustainable small business.",
        "status": "Completed",
        "action": "View \nRecommendations",
        "image": "assets/icons/cafe.png",
      },
      {
        "title": "My First Home Loan",
        "desc":
            "Explore loan options, interest rates, and payment schedules for buying your first home.",
        "status": "Ongoing",
        "action": "Continue",
        "image": "assets/icons/home.png",
      },
      {
        "title": "Retirement Plan",
        "desc":
            "Calculate savings, investments, and monthly contributions to secure your future lifestyle.",
        "status": "Completed",
        "action": "View \nRecommendations",
        "image": "assets/icons/retirement.png",
      },
      {
        "title": "Emergency Fund",
        "desc":
            "Prepare for unexpected situations by setting aside 3-6 months of living expenses.",
        "status": "Completed",
        "action": "View \nRecommendations",
        "image": "assets/icons/emergency.png",
      },
      {
        "title": "Investment Plan",
        "desc":
            "Explore stocks, bonds, and mutual funds to grow your wealth with diversified strategies.",
        "status": "Ongoing",
        "action": "Continue",
        "image": "assets/icons/investment.png",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/agapai_logo.png', height: 30),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Scenarios",
                style: GoogleFonts.poppins(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Track your finished and ongoing what-if stories",
                style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Grid inside scroll view
              GridView.builder(
                itemCount: scenarios.length,
                shrinkWrap: true, // 👈 makes grid take only needed height
                physics:
                    const NeverScrollableScrollPhysics(), // 👈 disable grid scroll
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final item = scenarios[index];
                  final isCompleted = item["status"] == "Completed";

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // icon
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                item["image"]!,
                                fit: BoxFit.contain,
                              ),
                            ),

                            // status
                            Transform.translate(
                              offset: Offset(0, -16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? Color(0xFFE3F3E3)
                                      : Color(0xFFFFEECD),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  item["status"]!,
                                  style: GoogleFonts.poppins(
                                    color: isCompleted
                                        ? Color(0xFF588158)
                                        : Color(0xFFC16306),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Status Badge
                        const SizedBox(height: 8),
                        // Title
                        Text(
                          item["title"]!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Description
                        Expanded(
                          child: Text(
                            item["desc"]!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0xFF252525),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _showSnackbar(
                            context,
                            "${item["action"]} - Not yet working",
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                item["action"]!,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFA42A25),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Color(0xFFA42A25),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
