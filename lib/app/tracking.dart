import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackOrderPage extends StatelessWidget {
  final List<Map<String, dynamic>> activeOrders = [
    {
      "orderId": "REQ001",
      "company": "Eagle Express",
      "from": "Cairo",
      "to": "Alexandria",
      "status": "on_the_way",
      "eta": "2 days",
      "date": "2025-04-16",
    },
    {
      "orderId": "REQ002",
      "company": "FastShip Co.",
      "from": "Giza",
      "to": "Mansoura",
      "status": "pending",
      "eta": "3 days",
      "date": "2025-04-17",
    },
  ];

  String getStatusText(String status) {
    switch (status) {
      case "pending":
        return "Pending Confirmation";
      case "accepted":
        return "Accepted by Company";
      case "on_the_way":
        return "Package is On the Way";
      case "delivered":
        return "Delivered Successfully";
      default:
        return "Unknown Status";
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.hourglass_top_rounded;
      case "accepted":
        return Icons.assignment_turned_in;
      case "on_the_way":
        return Icons.local_shipping_rounded;
      case "delivered":
        return Icons.check_circle_rounded;
      default:
        return Icons.help_outline;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange.shade600;
      case "accepted":
        return Colors.blue.shade600;
      case "on_the_way":
        return Colors.indigo.shade700;
      case "delivered":
        return Colors.green.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FD),
      appBar: AppBar(
        title: Text('Track Orders', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activeOrders.length,
        itemBuilder: (context, index) {
          final order = activeOrders[index];
          final statusColor = getStatusColor(order["status"]);
          final icon = getStatusIcon(order["status"]);
          final statusText = getStatusText(order["status"]);

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.indigo.shade700, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Order ID: ${order["orderId"]}',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.business, size: 18, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text(order["company"], style: GoogleFonts.poppins(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text('${order["from"]} → ${order["to"]}', style: GoogleFonts.poppins(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: statusColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            statusText,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 18, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text('ETA: ${order["eta"]}', style: GoogleFonts.poppins(fontSize: 13)),
                      const Spacer(),
                      Text('Date: ${order["date"]}', style: GoogleFonts.poppins(fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController _controller = TextEditingController();
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: Row(
                                children: [
                                  Icon(Icons.report_problem_rounded, color: Colors.red.shade700),
                                  const SizedBox(width: 8),
                                  Text("Report Issue", style: GoogleFonts.poppins()),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Order ID: ${order["orderId"]}",
                                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _controller,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: "Describe the issue...",
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel", style: GoogleFonts.poppins()),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade700,
                                  ),
                                  onPressed: () {
                                    final complaintText = _controller.text.trim();
                                    if (complaintText.isNotEmpty) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Complaint sent successfully")),
                                      );
                                      // TODO: Send to backend or store it
                                    }
                                  },
                                  child: Text("Send", style: GoogleFonts.poppins(color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.report_gmailerrorred_outlined, color: Colors.red.shade600),
                      label: Text(
                        "Report Issue",
                        style: GoogleFonts.poppins(color: Colors.red.shade600, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
