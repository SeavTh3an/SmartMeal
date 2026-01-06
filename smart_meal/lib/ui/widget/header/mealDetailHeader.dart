import 'package:flutter/material.dart';

class MealDetailHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final String? title;

  const MealDetailHeader({super.key, this.onMenuTap, this.title});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _MealDetailClipper(),
      child: Container(
        height: 180,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBF4B1), Color(0xFF608D43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: onMenuTap,
                ),
              ),
              if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealDetailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 10,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
