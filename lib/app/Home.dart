import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:untitled9/userdata.dart';

import '../appcubit/cubit.dart';
import '../appcubit/state.dart';

class HomePage extends StatelessWidget {
  final List<String> banners = [
    'assets/1600w-7yCJvIHP5a4.webp',
    'assets/images.jpeg',
    'assets/images (1).jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        var cubit = context.read<AppCubit>();
        return Scaffold(
          backgroundColor: const Color(0xFFF3F6FD),
          appBar: AppBar(
            title: Text(
              'Welcome Back ${ufullName.split(' ').first} !',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.indigo.shade800,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Banner Slider with increased height
              CarouselSlider(
                options: CarouselOptions(
                  height: 240.0, // زوّدنا الارتفاع هنا
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 4),
                ),
                items: banners.map((bannerUrl) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      bannerUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // Quick Access
              Text(
                "Quick Access",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickTile(
                    icon: Icons.add_circle_outline,
                    label: "New Order",
                    color: Colors.indigo,
                    onTap: () {
                      cubit.ChangeCurrent(2);
                    },
                  ),
                  _buildQuickTile(
                    icon: Icons.local_shipping_outlined,
                    label: "Track",
                    color: Colors.orange,
                    onTap: () {
                      cubit.ChangeCurrent(5);
                    },
                  ),
                  _buildQuickTile(
                    icon: Icons.history,
                    label: "History",
                    color: Colors.green,
                    onTap: () {
                      cubit.ChangeCurrent(1);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Statistics
              Text(
                "Your Statistics",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Orders", "12", Icons.assignment_outlined, Colors.blue),
                  _buildStatCard("Delivered", "10", Icons.check_circle_outline, Colors.green),
                  _buildStatCard("Pending", "2", Icons.hourglass_bottom, Colors.orange),
                ],
              ),

              const SizedBox(height: 30),

              // Recent Shipments
              Text(
                "Recent Shipments",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(Icons.local_shipping, color: Colors.indigo),
                      title: Text("Order #${index + 1} - Cairo to Giza"),
                      subtitle: Text("Status: In Transit"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigate to shipment details
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            Text(title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[700],
                )),
          ],
        ),
      ),
    );
  }
}
