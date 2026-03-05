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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Adaptable al tema
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Age Estimator', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- BUSCADOR ESTILO BENTO ---
            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: TextField(
                controller: _nameController,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Ingresa un nombre...',
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cake, color: Colors.orangeAccent),
                    onPressed: _handlePrediction,
                  ),
                ),
                onSubmitted: (_) => _handlePrediction(),
              ),
            ),
            
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)),

            // --- RESULTADO CENTRADO ---
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.orangeAccent)
                        : _buildResultIndicator(theme),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultIndicator(ThemeData theme) {
    if (_ageResult == null) {
      return Icon(Icons.hourglass_empty_rounded, size: 100, color: theme.dividerColor.withOpacity(0.1));
    }

    if (_ageResult!.age == null) {
      return Column(
        children: [
          Icon(Icons.help_outline_rounded, size: 100, color: Colors.redAccent.withOpacity(0.2)),
          const SizedBox(height: 16),
          const Text('No se pudo estimar la edad', style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    final int age = _ageResult!.age!;
    String status;
    IconData icon;
    Color accentColor;

    if (age < 30) {
      status = 'Joven';
      icon = Icons.skateboarding;
      accentColor = Colors.greenAccent;
    } else if (age < 60) {
      status = 'Adulto';
      icon = Icons.person;
      accentColor = Colors.orangeAccent;
    } else {
      status = 'Anciano';
      icon = Icons.elderly;
      accentColor = Colors.purpleAccent;
    }

    return Column(
      key: ValueKey(age),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Indicador circular con Neón
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: accentColor.withOpacity(0.5), width: 3),
            boxShadow: [
              BoxShadow(color: accentColor.withOpacity(0.2), blurRadius: 40, spreadRadius: 5)
            ]
          ),
          child: Icon(icon, size: 80, color: accentColor),
        ),
        const SizedBox(height: 30),
        Text(
          age.toString(),
          style: theme.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: accentColor),
        ),
        Text(
          'AÑOS',
          style: theme.textTheme.bodySmall?.copyWith(letterSpacing: 8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Etiqueta de estado estilo Bento
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: accentColor.withOpacity(0.3)),
          ),
          child: Text(
            status.toUpperCase(),
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
      ],
    );
  }
}