import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled9/userdata.dart';

import '../appcubit/cubit.dart';
import '../appcubit/state.dart';
import '../models/order model.dart';

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
    if (ordersList.isEmpty) {
      return Center(
        child: Text(
          'No Orders Found',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    List<OrderModel> sortedOrders = [...ordersList];
    sortedOrders.sort((a, b) => b.createdAtUtc.compareTo(a.createdAtUtc));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedOrders.length,
      itemBuilder: (context, index) {
        final order = sortedOrders[index];
        return InkWell(
          onTap: () {
            var cubit = BlocProvider.of<AppCubit>(context);
            cubit.fetchOffersByOrderId(order.id, utoken);
            cubit.ORDERID = order.id;
            cubit.offers = [];
            cubit.ChangeCurrent(4);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                'Created At: ${order.createdAtUtc.toLocal().toString().split(' ')[0]}',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Owner: ${order.ownerName}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Company: ${order.companyName ?? 'Not Assigned'}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
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
              Text(
                'Weight: ${order.weightInKg} kg | Size: ${order.packageSize}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Details: ${order.details}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
