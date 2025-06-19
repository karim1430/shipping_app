import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled9/userdata.dart';

import '../appcubit/cubit.dart';
import '../appcubit/state.dart';

class AddOrderPage extends StatelessWidget {
  AddOrderPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();

  final ValueNotifier<String> selectedSize = ValueNotifier<String>('Medium');

  final List<String> sizes = ['Small', 'Medium', 'Large'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text('Place Order', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: BlocBuilder<AppCubit, AppState>(
  builder: (context, state) {
    var cubit = context.read<AppCubit>();
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInput('Customer Name', nameController),
              _buildInput('Pickup Location', fromController),
              _buildInput('Drop-off Location', toController),
              _buildInput('Weight (kg)', weightController, keyboard: TextInputType.number),

              const SizedBox(height: 20),
              Text(
                'Select Package Size',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<String>(
                valueListenable: selectedSize,
                builder: (context, value, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: sizes.map((size) {
                      final isSelected = value == size;
                      return GestureDetector(
                        onTap: () => selectedSize.value = size,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.indigo : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.indigo : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              )
                            ]
                                : [],
                          ),
                          child: Text(
                            size,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(selectedSize.value) ;
                    print(selectedSize.toString()) ;
                    cubit.createOrder(pickupLocation: fromController.text, destination: toController.text, weightInKg:  int.parse(weightController.text), packageSize:selectedSize.value.toString(), details: "", token: utoken) ;
                    if (state is OrderSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("The request has been registered successfully")),
                      );
                    } else if (state is OrderError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("The request was not registered")),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'Place Order',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      );
  },
),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (value) => value == null || value.isEmpty ? 'This field is required' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
