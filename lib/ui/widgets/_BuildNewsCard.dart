import 'package:flutter/material.dart';

class DevNewsCard extends StatelessWidget {
  final String title;
  final String excerpt;
  final String imageUrl;
  final String author;
  final String date;
  final VoidCallback onTap;

  const DevNewsCard({
    super.key,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6), // Oscurece la imagen para leer el texto
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF673AB7).withOpacity(0.8), // Estilo 'GUIDE'
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("GUIDE", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                excerpt,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const CircleAvatar(radius: 10, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 12, color: Colors.white)),
                  const SizedBox(width: 8),
                  Text("$author • $date", style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  const Spacer(),
                  const Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}