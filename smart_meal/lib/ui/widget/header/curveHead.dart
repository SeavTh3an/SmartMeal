import 'package:flutter/material.dart';

class CurvedHeader extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onMenuTap;
  final String? title;

  const CurvedHeader({super.key, this.child, this.onMenuTap, this.title});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CurvedHeaderClipper(),
      child: Container(
        height: 170,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBF4B1), Color(0xFF608D43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      color: Colors.black,
                      onPressed: onMenuTap,
                    ),
                  ),
                  if (title != null)
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }
}

class _CurvedHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height - 30); // left bottom

    path.cubicTo(
      size.width * 0.2,
      size.height + 20, // left control point
      size.width * 0.35,
      size.height - 50, // middle-left control
      size.width * 0.5,
      size.height - 30, // middle point
    );

    path.cubicTo(
      size.width * 0.65,
      size.height - 10, // middle-right control
      size.width * 0.8,
      size.height + 20, // right control point
      size.width,
      size.height - 30, // right bottom
    );

    path.lineTo(size.width, 0); // top-right
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
