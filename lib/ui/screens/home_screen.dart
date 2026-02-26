import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {


    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea( // Primer div

        child: SingleChildScrollView( // Esto es para decir que solo habra uno
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical:20.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
            ],
          ),
        )
      ),
    );
  }

  // header del dashboard, con el titulo y el icono a la derecha
  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'DASHBOARD', 
              style: theme.textTheme.titleSmall!
                      .copyWith(letterSpacing: 2, fontWeight: FontWeight.w800)
                      // CORRECCIÓN: Usamos titleSmall de nuestro theme para el subtítulo
                      // Modificamos el style para agregar 2 cosas mas
            ), 
            const SizedBox(height: 4), // Para dar espacio
            RichText(
              text: TextSpan(
                text: 'ToolBox',
                style: theme.textTheme.titleLarge,
                children: [
                  TextSpan(
                    text: '.',
                    style: TextStyle(color: theme.splashColor)
                  )
                ]
              ),
            ),

          ],
        ),
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/180717493?s=400&u=eeb63082d5b58b988e8dd533ef828d3ddf5aa085&v=4'),
          ),
        )
      ],
    );
  }

}
