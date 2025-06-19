import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/companyModel.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final CompanyModel company;

  const CompanyDetailsScreen({Key? key, required this.company}) : super(key: key);

  Widget buildInfoTile(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          content.isNotEmpty ? content : "Not available",
          style: GoogleFonts.cairo(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          company.name,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: company.logo.isNotEmpty
                    ? Image.network(
                  company.logo,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 80),
                )
                    : const Icon(Icons.image_not_supported, size: 80),
              ),
            ),
            const SizedBox(height: 16),
            buildInfoTile("Description", company.description),
            buildInfoTile("About the Company", company.about),
            buildInfoTile("Advantages", company.advantages),
            buildInfoTile("Disadvantages", company.disadvantages),
            buildInfoTile("Address", company.mainAddress),
            buildInfoTile("Manager", company.responsibleManager),
            buildInfoTile("Working Hours", company.workTime),
            buildInfoTile("Tax Number", company.taxNumber),
            buildInfoTile("Zip Code", company.zipCode),
            buildInfoTile("Company Email", company.email),
            buildInfoTile("Company Phone", company.phoneNumber),
            const Divider(),
            buildInfoTile("Owner Name", company.ownerName),
            buildInfoTile("Owner Email", company.ownerEmail),
            buildInfoTile("Owner Phone", company.ownerPhoneNumber),
            const SizedBox(height: 20), // مساحة إضافية في الأسفل
          ],
        ),
      ),
    );
  }
}
