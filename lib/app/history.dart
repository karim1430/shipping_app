import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../appcubit/cubit.dart';
import '../appcubit/state.dart'; // لو عندك ملف الستيتات
import '../models/order model.dart'; // تأكد ان دا هو ملف الموديل بتاع الأوردرات

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Placed':
        return Colors.green.shade600;
      case 'Pending':
        return Colors.amber.shade800;
      case 'Delivered':
        return Colors.blue.shade600;
      case 'Cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  TextStyle getStatusTextStyle(String status) {
    return GoogleFonts.poppins(
      color: getStatusColor(status),
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var cubit = context.read<AppCubit>();

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: const Color(0xFFF7F9FC),
            appBar: AppBar(
              title: Text(
                'Order History',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              automaticallyImplyLeading: false,
              bottom: TabBar(
                isScrollable: true,
                labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(),
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Placed'),
                  Tab(text: 'Delivered'),
                  Tab(text: 'Cancelled'),
                ],
              ),
              backgroundColor: Colors.indigo.shade700,
            ),
            body: state is OrderLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              children: [
                buildOrderList(context, cubit.orders.where((o) => o.status == 'Pending').toList()),
                buildOrderList(context, cubit.orders.where((o) => o.status == 'Placed').toList()),
                buildOrderList(context, cubit.orders.where((o) => o.status == 'Delivered').toList()),
                buildOrderList(context, cubit.orders.where((o) => o.status == 'Cancelled').toList()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildOrderList(BuildContext context, List<OrderModel> ordersList) {
    return ordersList.isEmpty
        ? Center(
      child: Text(
        'No Orders Found',
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
      ),
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ordersList.length,
      itemBuilder: (context, index) {
        final order = ordersList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID & Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.id}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: getStatusColor(order.status).withOpacity(0.1),
                      border: Border.all(color: getStatusColor(order.status)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status,
                      style: getStatusTextStyle(order.status),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Owner Name
              Text(
                'Owner: ${order.ownerName}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
              // Company Name
              Text(
                'Company: ${order.companyName ?? 'Not Assigned'}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
              // Pickup & Destination
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: Colors.blueGrey.shade600),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'From ${order.pickupLocation} to ${order.destination}',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Weight & Size
              Text(
                'Weight: ${order.weightInKg} kg | Size: ${order.packageSize}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
              // Details
              Text(
                'Details: ${order.details}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
              // Created Date
              Text(
                "" ,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
