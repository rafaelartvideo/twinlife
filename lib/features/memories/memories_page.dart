import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/app/widgets/twin_scaffold.dart';

class MemoriesPage extends StatelessWidget {
  const MemoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TwinPageHeader(
            title: 'Memórias',
            subtitle: 'Fotos, recados e dedicatórias que contam a história de vocês.',
            trailing: IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 245,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDAB69C), Color(0xFF76283A)],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Nossas memórias\nfavoritas ♡',
                style: GoogleFonts.caveat(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (final item in const [
                (Color(0xFFD9B9A2), Icons.wb_twilight_outlined),
                (Color(0xFFB97A68), Icons.local_cafe_outlined),
                (Color(0xFFE5CDB9), Icons.pets_outlined),
              ]) ...[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: item.$1,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(item.$2, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          const TwinSectionTitle('Hoje', action: 'Ver todos'),
          const SizedBox(height: 14),
          const _MemoryNote(
            icon: Icons.music_note_rounded,
            title: 'Música dedicada',
            text: '“Essa me lembra o começo de tudo.”',
          ),
          const SizedBox(height: 12),
          const _MemoryNote(
            icon: Icons.favorite_rounded,
            title: 'Recado do dia',
            text: 'Você faz a vida ser mais leve ♡',
          ),
        ],
      ),
    );
  }
}

class _MemoryNote extends StatelessWidget {
  const _MemoryNote({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TwinColors.sand.withValues(alpha: .6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: TwinColors.ivory,
            child: Icon(icon, color: TwinColors.burgundy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(color: TwinColors.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
