import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final String title;
  final String imagePath;

  const HomeHeader({
    super.key,
    this.onMenuTap,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, 
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Wave background
          ClipPath(
            clipper: HomeWaveClipper(),
            child: Container(
              height: 250, 
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFCBF4B1), Color(0xFF608D43)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Menu button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: onMenuTap,
            ),
          ),

          // Title 
          Positioned(
            top: 80,
            left: 80,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF264016), 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Food image 
          Positioned(
            bottom: 0,
            right: 16, 
            child: Image.asset(
              imagePath,
              width: 180,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for Home Wave
class HomeWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30); // start left bottom

    // Big wave left to center
    path.quadraticBezierTo(
      size.width * 0.25, size.height + 40,
      size.width * 0.5, size.height - 40,
    );

    // Smaller wave center to right
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 100,
      size.width, size.height - 20,
    );

    path.lineTo(size.width, 0); // top right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
