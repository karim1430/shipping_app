import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingOffersPage extends StatelessWidget {
  final List<Map<String, dynamic>> userOrders = [
    {
      "id": "REQ001",
      "offers": [
        {
          "offerId": "OFFER001",  // إضافة ID خاص بالعرض
          "company": "Eagle Express",
          "clientName": "Ahmed Ali",
          "from": "Cairo",
          "to": "Alexandria",
          "weight": "3 kg",
          "size": "40x30x20 cm",
          "price": 80,
          "deliveryTime": "2 days",
          "date": "2025-04-16",
          "note": "Please ensure someone is available for pickup"
        },
        {
          "offerId": "OFFER002",  // إضافة ID خاص بالعرض
          "company": "OnTime Delivery",
          "clientName": "Ahmed Ali",
          "from": "Cairo",
          "to": "Alexandria",
          "weight": "3 kg",
          "size": "40x30x20 cm",
          "price": 95,
          "deliveryTime": "1 day",
          "date": "2025-04-16",
          "note": null
        },
      ]
    },
    {
      "id": "REQ002",
      "offers": [
        {
          "offerId": "OFFER003",  // إضافة ID خاص بالعرض
          "company": "FastShip Co.",
          "clientName": "Sarah Mohamed",
          "from": "Giza",
          "to": "Mansoura",
          "weight": "5 kg",
          "size": "50x40x25 cm",
          "price": 110,
          "deliveryTime": "3 days",
          "date": "2025-04-17",
          "note": "Delivery before 5 PM"
        }
      ]
    }
  ];

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: userOrders.length,
        itemBuilder: (context, index) {
          final order = userOrders[index];
          final offers = order['offers'] as List<dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: ${order["id"]}',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 10),
              ...offers.map((offer) => buildOfferCard(offer)).toList(),
              const Divider(thickness: 2, height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget buildOfferCard(Map<String, dynamic> offer) {
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
            Text('Company: ${offer["company"]}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Client: ${offer["clientName"]}', style: GoogleFonts.poppins()),
            Text('From: ${offer["from"]} → To: ${offer["to"]}', style: GoogleFonts.poppins()),
            Text('Weight: ${offer["weight"]}', style: GoogleFonts.poppins()),
            Text('Size: ${offer["size"]}', style: GoogleFonts.poppins()),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price: ${offer["price"]} EGP', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Time: ${offer["deliveryTime"]}', style: GoogleFonts.poppins()),
              ],
            ),
            Text('Date: ${offer["date"]}', style: GoogleFonts.poppins()),
            if (offer["note"] != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Note: ${offer["note"]}', style: GoogleFonts.poppins(color: Colors.black87)),
              ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // إرسال ID العرض إلى الـ Backend عند اختيار العرض
                  final offerId = offer["offerId"];
                  print("Selected Offer ID: $offerId");
                  // هنا تقدر تضيف الفنكشن التي تقوم بإرسال الـ offerId إلى الـ Backend
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
