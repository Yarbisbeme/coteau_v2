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
  final GenderService _genderService = GenderService(); 
  
  GenderModel? _genderResult; 
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handlePrediction() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _genderService.fetchGender(name);
      setState(() => _genderResult = result);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Se adapta al modo claro/oscuro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Gender Predictor', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSearchInput(theme),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)),
            
            // Usamos Expanded + Center para que el resultado siempre esté en el centro vertical
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _isLoading 
                      ? const CircularProgressIndicator()
                      : _buildResultContent(theme),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color, // Color dinámico
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: _nameController,
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Enter name...',
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: _handlePrediction,
          ),
        ),
        onSubmitted: (_) => _handlePrediction(),
      ),
    );
  }

  Widget _buildResultContent(ThemeData theme) {
    if (_genderResult == null) {
      return Icon(Icons.face_outlined, size: 100, color: theme.dividerColor.withOpacity(0.2));
    }

    final isMale = _genderResult!.gender == 'male';
    final accentColor = isMale ? const Color(0xFF03A9F4) : const Color(0xFFE91E63);
    final icon = isMale ? Icons.male_rounded : Icons.female_rounded;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Círculo de género
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: accentColor.withOpacity(0.3), width: 2),
          ),
          child: Icon(icon, size: 100, color: accentColor),
        ),
        const SizedBox(height: 24),
        Text(
          _genderResult!.name.toUpperCase(),
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        Text(
          isMale ? "MASCULINE" : "FEMININE",
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 14),
        ),
        const SizedBox(height: 40),
        
        // Tarjetas Bento de estadísticas
        Row(
          children: [
            _buildStatCard(theme, "Probability", "${((_genderResult!.probability ?? 0.0) * 100).toInt()}%", accentColor),
            const SizedBox(width: 16),
            _buildStatCard(theme, "Sample Size", _genderResult!.count.toString(), Colors.blueGrey),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(ThemeData theme, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}