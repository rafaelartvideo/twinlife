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
      backgroundColor: TwinColors.ivory,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 46,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TopBar(),
                      const SizedBox(height: 24),
                      const _Hero(),
                      const SizedBox(height: 28),
                      Text(
                        'Antes de viver tudo isso,\nvamos cuidar do seu espaço.',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 34,
                          height: 1.02,
                          fontWeight: FontWeight.w600,
                          color: TwinColors.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'O TwinLife foi pensado para ser íntimo, leve e seguro. '
                        'Vocês escolhem o que compartilhar e podem alterar tudo depois.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: TwinColors.muted,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 22),
                      _PermissionCard(
                        icon: Icons.auto_awesome_outlined,
                        title: 'Personalizar a experiência',
                        description:
                            'Permite usar os dados do casal para criar lembretes, resumos e insights personalizados.',
                        value: dataAllowed,
                        onChanged: (value) =>
                            setState(() => dataAllowed = value),
                      ),
                      const SizedBox(height: 12),
                      _PermissionCard(
                        icon: Icons.photo_library_outlined,
                        title: 'Fotos e vídeos',
                        description:
                            'Permite escolher memórias da galeria para álbuns, recados e dedicatórias.',
                        value: galleryAllowed,
                        onChanged: (value) =>
                            setState(() => galleryAllowed = value),
                      ),
                      const SizedBox(height: 20),
                      const _PrivacyNote(),
                      const Spacer(),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          onPressed: widget.onContinue,
                          style: FilledButton.styleFrom(
                            backgroundColor: TwinColors.burgundy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Começar nossa história',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 19),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'Ao continuar, vocês poderão revisar as permissões a qualquer momento.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TwinColors.muted,
                            fontSize: 10.5,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BrandMark(),
        const SizedBox(width: 10),
        Text(
          'TwinLife',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 29,
            height: 1,
            fontWeight: FontWeight.w700,
            color: TwinColors.burgundy,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: TwinColors.sand.withValues(alpha: .55),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Text(
            'PASSO 1 DE 4',
            style: TextStyle(
              color: TwinColors.mocha,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE6D4C4),
            Color(0xFFC58A79),
            Color(0xFF7A1E2D),
          ],
          stops: [0, .48, 1],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A7A1E2D),
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -32,
            top: -20,
            child: Icon(
              Icons.favorite_rounded,
              size: 190,
              color: Colors.white.withValues(alpha: .07),
            ),
          ),
          Positioned(
            left: -22,
            bottom: -32,
            child: Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: .12),
                  width: 26,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 24,
            left: 24,
            child: _CoupleMark(),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DOIS CAMINHOS, UMA VIDA',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: .72),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mais perto.\nMais vocês.',
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 34,
                    height: .95,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoupleMark extends StatelessWidget {
  const _CoupleMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 42,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: .55),
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .22),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: .55),
                ),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: TwinColors.burgundy,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.favorite_rounded,
        color: TwinColors.ivory,
        size: 18,
      ),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.fromLTRB(16, 15, 12, 15),
      decoration: BoxDecoration(
        color: value
            ? Colors.white
            : TwinColors.sand.withValues(alpha: .22),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: value
              ? TwinColors.sand.withValues(alpha: .78)
              : TwinColors.sand.withValues(alpha: .5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: value
                  ? TwinColors.sand.withValues(alpha: .58)
                  : TwinColors.ivory,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: value ? TwinColors.burgundy : TwinColors.mocha,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: TwinColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: TwinColors.muted,
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Switch.adaptive(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: TwinColors.burgundy,
            inactiveThumbColor: TwinColors.mocha,
            inactiveTrackColor: TwinColors.sand,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: TwinColors.sand.withValues(alpha: .28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 17,
            color: TwinColors.burgundy,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'O espaço do casal é privado. Vocês controlam o que é compartilhado.',
              style: TextStyle(
                color: TwinColors.mocha,
                fontSize: 10.5,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
