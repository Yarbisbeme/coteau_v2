import 'package:flutter/material.dart';
import '../../models/age_model.dart';
import '../../services/agify_service.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final AgeService _ageService = AgeService();
  
  AgeModel? _ageResult;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handlePrediction() async {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingresa un nombre.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _ageResult = null;
    });

    try {
      final result = await _ageService.predictAge(name);
      setState(() => _ageResult = result);
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 2,
        title: const Text('Age Estimator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ingrese su nombre',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF141414),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cake, color: Colors.orangeAccent),
                  onPressed: _handlePrediction,
                ),
              ),
              onSubmitted: (_) => _handlePrediction(),
            ),
            
            const SizedBox(height: 20),
            
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.center),

            const SizedBox(height: 40),

            Expanded(
              child: Center(
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.orangeAccent)
                    : _buildResultIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Lógica de clasificación de edad con UI Premium
  Widget _buildResultIndicator() {
    // 1. ESTADO INICIAL: Esperando a que el usuario escriba
    if (_ageResult == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cake_outlined, size: 100, color: Colors.white.withValues(alpha: 0.05)),
          const SizedBox(height: 16),
          Text('Esperando un nombre...', style: TextStyle(color: Colors.grey[700])),
        ],
      );
    }

    // 2. ESTADO DE ERROR: La API no encontró el nombre
    if (_ageResult!.age == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5), width: 2),
            ),
            child: const Icon(Icons.person_off, size: 80, color: Colors.redAccent),
          ),
          const SizedBox(height: 24),
          const Text(
            '¡Uy, qué misterio!',
            style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'El oráculo de datos no pudo\nestimar la edad para este nombre.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      );
    }

    // 3. ESTADO DE ÉXITO: Tenemos una edad
    final int age = _ageResult!.age!;
    String status;
    IconData icon;
    Color accentColor;

    // Evaluamos la edad según los requerimientos
    if (age < 30) {
      status = 'Joven';
      icon = Icons.skateboarding; // Un ícono dinámico para los jóvenes
      accentColor = Colors.greenAccent;
    } else if (age >= 30 && age < 60) {
      status = 'Adulto';
      icon = Icons.person; // Representa la vida laboral/adulta
      accentColor = Colors.orangeAccent;
    } else {
      status = 'Anciano';
      icon = Icons.elderly; // Flutter tiene un ícono oficial para esto
      accentColor = Colors.purpleAccent;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: accentColor, width: 4),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.3), 
                blurRadius: 30, 
                spreadRadius: 5
              )
            ]
          ),
          child: Icon(icon, size: 80, color: accentColor),
        ),
        const SizedBox(height: 30),
        Text(
          age.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold, height: 1),
        ),
        const Text(
          'AÑOS',
          style: TextStyle(color: Colors.grey, fontSize: 16, letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status.toUpperCase(),
            style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
      ],
    );
  }

}