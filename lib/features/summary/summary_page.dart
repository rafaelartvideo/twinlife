import 'package:flutter/material.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/app/widgets/twin_scaffold.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TwinPageHeader(
            title: 'Nosso resumo',
            subtitle: 'Uma leitura leve da conexão de vocês nos últimos dias.',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: TwinColors.burgundy,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nível de conexão',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '84',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        height: 1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        '/100',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFE7B8B9),
                      size: 32,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: LinearProgressIndicator(
                    value: .84,
                    minHeight: 8,
                    backgroundColor: Color(0xFF954555),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      TwinColors.softGold,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '+12% de conexão neste mês',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: _Stat('184', 'momentos juntos')),
              SizedBox(width: 10),
              Expanded(child: _Stat('52', 'elogios trocados')),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(child: _Stat('12', 'dias seguidos')),
              SizedBox(width: 10),
              Expanded(child: _Stat('4', 'novas memórias')),
            ],
          ),
          const SizedBox(height: 28),
          const TwinSectionTitle(
            'Insights de vocês',
            action: 'Ver todos',
          ),
          const SizedBox(height: 14),
          const _Insight(
            Icons.favorite_outline_rounded,
            'Vocês estão mais presentes',
            'Tiveram mais momentos de qualidade juntos nesta semana.',
          ),
          const SizedBox(height: 10),
          const _Insight(
            Icons.chat_bubble_outline_rounded,
            'Mais palavras que aproximam',
            'Os elogios aumentaram e isso fortalece a conexão de vocês.',
          ),
          const SizedBox(height: 10),
          const _Insight(
            Icons.balance_rounded,
            'Equilíbrio em evolução',
            'A rotina e os momentos a dois ficaram mais equilibrados.',
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: TwinColors.sand.withValues(alpha: .48),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: TwinColors.terracotta,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Que tal reservarem um tempo esta semana para fazer algo novo juntos?',
                    style: TextStyle(
                      color: TwinColors.ink,
                      height: 1.45,
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

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: TwinColors.sand.withValues(alpha: .55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: TwinColors.burgundy,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: TwinColors.muted,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Insight extends StatelessWidget {
  const _Insight(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: TwinColors.sand.withValues(alpha: .5),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: TwinColors.ivory,
            child: Icon(icon, color: TwinColors.burgundy),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: TwinColors.muted,
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: TwinColors.mocha,
          ),
        ],
      ),
    );
  }
}
