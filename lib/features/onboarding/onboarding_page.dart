import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinlife/app/theme/twin_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool dataAllowed = true;
  bool galleryAllowed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 24, 26, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _BrandMark(),
                  const SizedBox(width: 10),
                  Text(
                    'TwinLife',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: TwinColors.burgundy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE5CDB9), Color(0xFF8C4B4B)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -28,
                      top: 25,
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 190,
                        color: Colors.white.withOpacity(.08),
                      ),
                    ),
                    const Positioned(
                      left: 24,
                      right: 24,
                      bottom: 26,
                      child: Text(
                        'Dois caminhos,\numa vida mais linda.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.05,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Antes de começarmos',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Escolham com tranquilidade o que o TwinLife pode acessar. Vocês poderão revisar essas permissões depois.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 22),
              _PermissionCard(
                icon: Icons.analytics_outlined,
                title: 'Utilização de dados',
                description:
                    'Usamos os dados para personalizar a experiência do casal, gerar insights e manter os recursos sincronizados.',
                value: dataAllowed,
                onChanged: (value) => setState(() => dataAllowed = value),
              ),
              const SizedBox(height: 12),
              _PermissionCard(
                icon: Icons.photo_library_outlined,
                title: 'Acesso à galeria',
                description:
                    'Permite criar álbuns, guardar memórias e enviar fotos e vídeos para o espaço compartilhado.',
                value: galleryAllowed,
                onChanged: (value) => setState(() => galleryAllowed = value),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: widget.onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: TwinColors.burgundy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Privacidade e transparência desde o início.',
                  style: TextStyle(color: TwinColors.muted, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: TwinColors.burgundy,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.favorite_rounded, color: TwinColors.ivory, size: 20),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TwinColors.sand.withOpacity(.72)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: TwinColors.sand.withOpacity(.55),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: TwinColors.burgundy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 5),
                Text(description, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: value,
            activeColor: TwinColors.burgundy,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
