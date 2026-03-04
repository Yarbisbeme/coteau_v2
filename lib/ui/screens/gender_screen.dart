import 'package:coteau_v2/services/genderize_service.dart';
import 'package:flutter/material.dart';
import '../../models/gender_model.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GenderService _genderService = GenderService(); // Instanciamos nuestro servicio
  
  GenderModel? _genderResult; // Guardamos el modelo completo
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handlePrediction() async {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa un nombre.';
        _genderResult = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _genderResult = null;
    });

    try {
      // Magia: La vista ya no sabe nada de HTTP ni JSON
      final result = await _genderService.fetchGender(name);
      setState(() {
        _genderResult = result;
      });
    } catch (e) {
      setState(() {
        // Limpiamos la excepción para mostrar solo el mensaje al usuario
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
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
        elevation: 0,
        title: const Text('Gender Predictor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                hintText: 'Ej. Yarbis, Irma, Carlos...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF141414),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blueAccent),
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
                    ? const CircularProgressIndicator(color: Colors.blueAccent)
                    : _buildResultIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultIndicator() {
    // Si no hemos buscado nada aún
    if (_genderResult == null) {
      return const Icon(Icons.face, size: 100, color: Color(0xFF222222));
    }

    Color bgColor;
    IconData icon;
    String label;

    // Evaluamos usando la propiedad del modelo
    if (_genderResult!.gender == 'male') {
      bgColor = Colors.blue; 
      icon = Icons.male;
      label = 'HOMBRE MASCULINO';
    } else if (_genderResult!.gender == 'female') {
      bgColor = Colors.pink; 
      icon = Icons.female;
      label = 'MUJER FEMENINA';
    } else {
      bgColor = Colors.grey;
      icon = Icons.question_mark;
      label = 'DESCONOCIDO (Ta raro mio)';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(60),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: bgColor, width: 4),
            boxShadow: [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.5),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ]
          ),
          child: Icon(icon, size: 120, color: bgColor),
        ),
        const SizedBox(height: 34),
        Text(
          label,
          style: TextStyle(color: bgColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

}