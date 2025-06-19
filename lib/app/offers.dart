import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled9/appcubit/cubit.dart';
import 'package:untitled9/appcubit/state.dart';
import 'package:untitled9/userdata.dart';

import '../models/Offer Model.dart';


class ShippingOffersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FD),
      appBar: AppBar(
        title: Text('Shipping Offers', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          var cubit = context.read<AppCubit>();
          final offers = cubit.offers; // الليست من الكيوبت مباشرة
          if (offers.isEmpty) {
            return Center(
              child: Text(
                "No offers available",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return buildOfferCard(offer, context, cubit);
            },
          );
        },
      ),
    );
  }

  Widget buildOfferCard(OfferModel offer, BuildContext context, AppCubit cubit) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${offer.companyName}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Customer: ${offer.customerName}', style: GoogleFonts.poppins()),
            Text('Order ID: ${offer.orderId}', style: GoogleFonts.poppins()),
            Text('Price: ${offer.price} EGP', style: GoogleFonts.poppins()),
            Text('Estimated Delivery: ${offer.estimatedDeliveryTimeInDays} days', style: GoogleFonts.poppins()),
            Text('Status: ${offer.status}', style: GoogleFonts.poppins()),
            Text('Created At: ${offer.createdAtUtc}', style: GoogleFonts.poppins()),
            Text('Delivery Date: ${offer.deliveryDateUtc}', style: GoogleFonts.poppins()),
            if (offer.notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Notes: ${offer.notes}', style: GoogleFonts.poppins(color: Colors.black87)),
              ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    builder: (context) {
                      final cardController = TextEditingController();
                      final expiryController = TextEditingController();
                      final cvvController = TextEditingController();
                      final formKey = GlobalKey<FormState>();

                      return Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.credit_card, size: 60, color: Colors.indigo),
                                SizedBox(height: 10),
                                Text(
                                  'Secure Payment',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Enter your Visa card details below',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                SizedBox(height: 20),

                                // Card Number Field
                                TextFormField(
                                  controller: cardController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 16,
                                  decoration: InputDecoration(
                                    labelText: 'Card Number',
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                    prefixIcon: Icon(Icons.credit_card, color: Colors.indigo),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    filled: true,
                                    fillColor: Colors.indigo.shade50,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length != 16) {
                                      return 'Enter 16-digit card number';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 12),

                                Row(
                                  children: [
                                    // Expiry Date Field
                                    Expanded(
                                      child: TextFormField(
                                        controller: expiryController,
                                        keyboardType: TextInputType.datetime,
                                        maxLength: 5,
                                        decoration: InputDecoration(
                                          labelText: 'Expiry',
                                          hintText: 'MM/YY',
                                          prefixIcon: Icon(Icons.calendar_today, color: Colors.indigo),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          filled: true,
                                          fillColor: Colors.indigo.shade50,
                                        ),
                                        validator: (value) {
                                          if (value == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                                            return 'Invalid expiry';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),

                                    // CVV Field
                                    Expanded(
                                      child: TextFormField(
                                        controller: cvvController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 3,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'CVV',
                                          hintText: '***',
                                          prefixIcon: Icon(Icons.lock, color: Colors.indigo),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          filled: true,
                                          fillColor: Colors.indigo.shade50,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.length != 3) {
                                            return 'Invalid CVV';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          title: Text('Processing Payment...'),
                                          content: Row(
                                            children: [
                                              CircularProgressIndicator(color: Colors.indigo),
                                              SizedBox(width: 20),
                                              Text('Please wait'),
                                            ],
                                          ),
                                        ),
                                      );

                                      Future.delayed(Duration(seconds: 2), () {
                                        cubit.updateOfferStatus(offerId: offer.id, token: utoken, status: "Pending", paymentMethod: "CreditCard") ;
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('✅ Payment Successful'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.payment),
                                  label: Text('Pay Now', style: TextStyle(fontSize: 18)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),

                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },


                icon: const Icon(Icons.check_circle_outline),
                label: Text('Select Offer', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
