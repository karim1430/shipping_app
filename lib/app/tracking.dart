import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../appcubit/cubit.dart';
import '../appcubit/state.dart';
import '../models/order model.dart';

class TrackOrderPage extends StatelessWidget {
  const TrackOrderPage({super.key});

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
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          var cubit = context.read<AppCubit>();
          var placedOrders = cubit.placedOrders;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: placedOrders.length,
            itemBuilder: (context, index) {
              final order = placedOrders[index];
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
                          Icon(Icons.local_shipping, color: Colors.indigo.shade700),
                          SizedBox(width: 8),
                          Text('Order ID: ${order.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.person, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Owner: ${order.ownerName}', style: GoogleFonts.poppins(fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 8),
                      if(order.companyName != null)
                        Row(
                          children: [
                            Icon(Icons.business, size: 18, color: Colors.grey),
                            SizedBox(width: 6),
                            Text('Company: ${order.companyName}', style: GoogleFonts.poppins(fontSize: 14)),
                          ],
                        ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('${order.pickupLocation} → ${order.destination}', style: GoogleFonts.poppins(fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.monitor_weight, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Weight: ${order.weightInKg} Kg', style: GoogleFonts.poppins(fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.all_inbox, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Package Size: ${order.packageSize}', style: GoogleFonts.poppins(fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.attach_money, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Price: 1500 EGP', style: GoogleFonts.poppins(fontSize: 14)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.info, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Status: ${order.status}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.indigo)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.notes, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text('Details: ${order.details}', style: GoogleFonts.poppins(fontSize: 14)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.directions_car_filled, color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Order is on the way',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.date_range, size: 18, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Date: ${order.createdAtUtc.toLocal().toString().split(' ')[0]}', style: GoogleFonts.poppins(fontSize: 13)),
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              TextEditingController complaintController = TextEditingController();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    title: Row(
                                      children: [
                                        Icon(Icons.report_problem_rounded, color: Colors.red.shade700),
                                        SizedBox(width: 8),
                                        Text("Report Issue", style: GoogleFonts.poppins()),
                                      ],
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Order ID: ${order.id}",
                                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                                        ),
                                        SizedBox(height: 12),
                                        TextField(
                                          controller: complaintController,
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
                                          String complaintText = complaintController.text.trim();
                                          if (complaintText.isNotEmpty) {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Complaint sent successfully")),
                                            );
                                            print('Complaint for Order ${order.id}: $complaintText');
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Please write your complaint")),
                                            );
                                          }
                                        },
                                        child: Text("Send", style: GoogleFonts.poppins(color: Colors.white)),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },

                            icon: Icon(Icons.report_gmailerrorred, color: Colors.red),
                            label: Text(
                              "Report Issue",
                              style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'In Transit',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
