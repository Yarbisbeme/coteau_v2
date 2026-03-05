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
    // Validamos si la URL es válida para evitar el error de "No host specified"
    final bool hasValidUrl = imageUrl.isNotEmpty && imageUrl.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: (hasValidUrl) 
                ? NetworkImage(imageUrl) 
                // En lugar de AssetImage, usamos una imagen transparente o pequeña
                : const NetworkImage("https://via.placeholder.com/1x1/1A1A1A/1A1A1A.png") as ImageProvider,
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              // Si falla, Flutter simplemente no dibujará la imagen de fondo
              debugPrint("Imagen no disponible");
            },
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
                  color: const Color(0xFF673AB7).withOpacity(0.8),
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
                  const CircleAvatar(
                    radius: 10, 
                    backgroundColor: Colors.white24, 
                    child: Icon(Icons.person, size: 12, color: Colors.white)
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "$author • $date", 
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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