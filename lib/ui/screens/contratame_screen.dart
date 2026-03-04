import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContratameScreen extends StatelessWidget {
  const ContratameScreen({super.key});

  // Método para abrir el cliente de correo del celular
  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'yarbisbeme@ejemplo.com', // TODO: Pon tu correo real aquí
      query: 'subject=Oportunidad%20de%20Proyecto/Trabajo', // Asunto prellenado
    );

    if (!await launchUrl(emailLaunchUri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir la aplicación de correo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Hire Me', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. FOTO DE PERFIL Y NOMBRE
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.primaryColor, width: 3),
              ),
              child: const CircleAvatar(
                radius: 85,
                // Usamos la foto que arreglamos en el Dashboard
                backgroundImage: AssetImage('assets/images/yarbis.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Yarbis Beltré Mercedes',
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Software Developer & QA Engineer',
              style: TextStyle(color: theme.primaryColor, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.2),
            ),
            
            const SizedBox(height: 24),

            // 2. TARJETA DE "ACERCA DE MÍ"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: theme.colorScheme.onSurface),
                      const SizedBox(width: 12),
                      Text('About Me', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Desarrollador enfocado en crear soluciones eficientes, automatizadas y escalables. Apasionado por la mejora continua, la automatización de procesos y el aseguramiento de calidad (QA). Cuando no estoy codeando, probablemente me encuentres en el piano.',
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7), height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. TARJETA DE SKILLS (Tecnologías)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.code, color: theme.colorScheme.onSurface),
                      const SizedBox(width: 12),
                      Text('Tech Stack', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildSkillChip(theme, 'Next.Js / React'),
                      _buildSkillChip(theme, 'C# / .NET'),
                      _buildSkillChip(theme, 'Flutter / Dart'),
                      _buildSkillChip(theme, 'Python'),
                      _buildSkillChip(theme, 'SQL'),
                      _buildSkillChip(theme, 'Jira & TestRail'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 4. BOTONES DE ACCIÓN (Contacto)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _launchEmail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.mail_outline),
                label: const Text('Contact Me', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reutilizable para las "píldoras" de habilidades
  Widget _buildSkillChip(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Text(
        label,
        style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}