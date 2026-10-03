import 'package:flutter/material.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/app/widgets/twin_scaffold.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  static const _days = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TwinPageHeader(
            title: 'Nosso calendário',
            subtitle: 'Datas especiais, intimidade, compromissos e humor compartilhados.',
            trailing: IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: TwinColors.burgundy),
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: TwinColors.sand.withOpacity(.6)),
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.chevron_left_rounded, color: TwinColors.muted),
                    Text('Outubro de 2026', style: TextStyle(fontWeight: FontWeight.w800)),
                    Icon(Icons.chevron_right_rounded, color: TwinColors.muted),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: _days
                      .map((day) => Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  color: TwinColors.muted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: 35,
                  itemBuilder: (context, index) {
                    final day = index - 3;
                    final valid = day > 0 && day <= 31;
                    final selected = day == 3;
                    final hasEvent = [5, 9, 14, 20, 25].contains(day);
                    return Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: selected ? TwinColors.burgundy : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              valid ? '$day' : '',
                              style: TextStyle(
                                color: selected ? Colors.white : TwinColors.ink,
                                fontSize: 12,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                            if (valid && hasEvent)
                              Positioned(
                                bottom: 3,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: selected ? Colors.white : TwinColors.terracotta,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _Chip('Todos', TwinColors.burgundy, true),
              _Chip('Especiais', TwinColors.softGold, false),
              _Chip('Intimidade', TwinColors.terracotta, false),
              _Chip('Compromissos', TwinColors.mocha, false),
              _Chip('Humor', Color(0xFFC7A6AD), false),
            ],
          ),
          const SizedBox(height: 28),
          const TwinSectionTitle('Próximos'),
          const SizedBox(height: 14),
          const _EventTile(Icons.restaurant_outlined, 'Nosso jantar', 'Hoje • 20:00', 'Momento especial'),
          const SizedBox(height: 10),
          const _EventTile(Icons.movie_outlined, 'Noite de filme', 'Sexta • 21:00', 'Intimidade'),
          const SizedBox(height: 10),
          const _EventTile(Icons.flight_takeoff_rounded, 'Nossa viagem', '25 de outubro', 'Data especial'),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label, this.color, this.selected);

  final String label;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? TwinColors.burgundy : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TwinColors.sand.withOpacity(.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: selected ? Colors.white : color, shape: BoxShape.circle)),
          const SizedBox(width: 7),
          Text(label, style: TextStyle(color: selected ? Colors.white : TwinColors.ink, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile(this.icon, this.title, this.date, this.category);

  final IconData icon;
  final String title;
  final String date;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: TwinColors.sand.withOpacity(.55)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: TwinColors.ivory, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: TwinColors.burgundy),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('$category • $date', style: const TextStyle(color: TwinColors.muted, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: TwinColors.mocha),
        ],
      ),
    );
  }
}
