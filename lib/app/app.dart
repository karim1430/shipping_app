import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled9/userdata.dart';
import '../appcubit/cubit.dart';
import '../appcubit/state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, currentIndex) {
        var cubit = context.read<AppCubit>();
        if(cubit.i==0){
          cubit.getCompanies(utoken);
          cubit.getOrders(utoken) ;
          cubit.i = 2 ;
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea( // ✅ عشان المساحة اللي فوق
              child: IndexedStack(
                index: cubit.c,
                children: cubit.Screens,
              ),
            ),
            appBar: cubit.c == 7
                ? PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: ClipPath(
                clipper: CustomAppBarClipper(),
                child: Container(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome Back 👋",
                      style: GoogleFonts.cairo(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
                : PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: Colors.white,
              notchMargin: 6.0,
              child: SizedBox(
                height: 65.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final iconSpacing = screenWidth * 0.08 ;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side
                          Row(
                            children: [
                              _buildNavIcon(
                                icon: Icons.compare,
                                selected: cubit.c == 0,
                                onTap: () => cubit.ChangeCurrent(0),
                                spacing: iconSpacing,
                              ),
                              _buildNavIcon(
                                icon: Icons.history,
                                selected: cubit.c == 1,
                                onTap: () => cubit.ChangeCurrent(1),
                                spacing: iconSpacing,
                              ),
                            ],
                          ),
                          // Right side
                          Row(
                            children: [
                              _buildNavIcon(
                                icon: Icons.local_offer,
                                selected: cubit.c == 4,
                                onTap: () => cubit.ChangeCurrent(4),
                                spacing: iconSpacing,
                              ),
                              _buildNavIcon(
                                icon: Icons.person,
                                selected: cubit.c == 6,
                                onTap: () => cubit.ChangeCurrent(6),
                                spacing: 0,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cubit.ChangeCurrent(3); // Home
              },
              backgroundColor: Colors.blue.shade900,
              child: const Icon(
                Icons.home,
                size: 35,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    double spacing = 12.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: spacing),
      child: IconButton(
        icon: Icon(
          icon,
          color: selected ? Colors.blue.shade900 : Colors.grey,
        ),
        onPressed: onTap,
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomAppBarClipper oldClipper) => false;
}
