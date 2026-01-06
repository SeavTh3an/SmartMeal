import 'package:flutter/material.dart';

class CurvedHeader extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onMenuTap;
  final String? title;

  const CurvedHeader({
    super.key,
    this.child,
    this.onMenuTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFCBF4B1),
              Color(0xFF608D43),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: menu button at left, centered title
                Stack(
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
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
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
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
