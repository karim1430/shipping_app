import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled9/userdata.dart';

import '../Login/Login.dart'; // لإدارة البيانات المحلية

class ProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController(text: ufullName);
  final TextEditingController emailController = TextEditingController(text: uemail);
  final TextEditingController phoneController = TextEditingController(text: uphoneNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // لإزالة زر العودة
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              // مسح البيانات وتسجيل الخروج
              await _logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/user.png'), // Change path if needed
              ),
            ),
            const SizedBox(height: 20),
            buildField(title: 'Full Name', controller: nameController, icon: Icons.person),
            buildField(title: 'Email Address', controller: emailController, icon: Icons.email),
            buildField(title: 'Phone Number', controller: phoneController, icon: Icons.phone),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Save changes
                },
                icon: const Icon(Icons.save),
                label: Text(
                  'Save Changes',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.indigo.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.indigo.shade200,
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField({
    required String title,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: Icon(icon, color: Colors.indigo.shade700),
          labelStyle: GoogleFonts.poppins(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  // Function to handle Logout and redirect to Login screen
  Future<void> _logout(BuildContext context) async {
    // Clear user session or data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Clear stored data (e.g., session)

    // Redirect to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
