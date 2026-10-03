import 'package:flutter/material.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/app/widgets/twin_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TwinPageHeader(
            title: 'Bom dia,\nvocês dois ♡',
            subtitle: 'Mais um dia para construir uma vida incrível juntos.',
            trailing: CircleAvatar(
              radius: 22,
              backgroundColor: TwinColors.sand,
              child: const Icon(Icons.favorite_rounded, color: TwinColors.burgundy),
            ),
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: TwinColors.burgundy,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1 ano e 8 meses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'colecionando dias, planos e memórias',
                        style: TextStyle(color: Color(0xFFEFD8D9), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.all_inclusive_rounded, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const TwinSectionTitle('Nosso espaço'),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.18,
            children: const [
              _FeatureCard(Icons.calendar_month_outlined, 'Calendário', 'Planos, datas e momentos especiais'),
              _FeatureCard(Icons.photo_library_outlined, 'Álbum', 'Nossas memórias sempre por perto'),
              _FeatureCard(Icons.favorite_border_rounded, 'Painel de elogios', 'Palavras que aproximam'),
              _FeatureCard(Icons.auto_awesome_outlined, 'Chat com IA', 'Conselhos e conversas para vocês'),
              _FeatureCard(Icons.location_on_outlined, 'Localização 24h', 'Mais segurança no dia a dia'),
              _FeatureCard(Icons.mood_outlined, 'Humor', 'Como estamos hoje?'),
            ],
          ),
          const SizedBox(height: 28),
          const TwinSectionTitle('Hoje'),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TwinColors.sand.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.format_quote_rounded, color: TwinColors.terracotta),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pequenos momentos, grandes significados. Tudo isso é nós. ♡',
                    style: TextStyle(
                      color: TwinColors.ink,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
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

class _FeatureCard extends StatelessWidget {
  const _FeatureCard(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TwinColors.sand.withValues(alpha: .55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TwinColors.ivory,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: TwinColors.burgundy, size: 21),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: TwinColors.muted, fontSize: 10.5, height: 1.3),
          ),
        ],
      ),
    );
  }
}
