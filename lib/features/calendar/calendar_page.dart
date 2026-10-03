import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/features/onboarding/couple_setup.dart';

enum CalendarEntryType { fight, special, intimacy, commitment, cycle }

extension CalendarEntryTypeUi on CalendarEntryType {
  String get label {
    switch (this) {
      case CalendarEntryType.fight:
        return 'Brigas';
      case CalendarEntryType.special:
        return 'Especiais';
      case CalendarEntryType.intimacy:
        return 'Intimidade';
      case CalendarEntryType.commitment:
        return 'Compromissos';
      case CalendarEntryType.cycle:
        return 'Ciclo';
    }
  }

  String get singular {
    switch (this) {
      case CalendarEntryType.fight:
        return 'Briga';
      case CalendarEntryType.special:
        return 'Data especial';
      case CalendarEntryType.intimacy:
        return 'Intimidade';
      case CalendarEntryType.commitment:
        return 'Compromisso';
      case CalendarEntryType.cycle:
        return 'Menstruação';
    }
  }

  IconData get icon {
    switch (this) {
      case CalendarEntryType.fight:
        return Icons.forum_outlined;
      case CalendarEntryType.special:
        return Icons.favorite_outline_rounded;
      case CalendarEntryType.intimacy:
        return Icons.favorite_rounded;
      case CalendarEntryType.commitment:
        return Icons.event_note_outlined;
      case CalendarEntryType.cycle:
        return Icons.water_drop_outlined;
    }
  }

  Color get color {
    switch (this) {
      case CalendarEntryType.fight:
        return const Color(0xFFA34848);
      case CalendarEntryType.special:
        return TwinColors.softGold;
      case CalendarEntryType.intimacy:
        return TwinColors.terracotta;
      case CalendarEntryType.commitment:
        return TwinColors.mocha;
      case CalendarEntryType.cycle:
        return const Color(0xFFB65C78);
    }
  }
}

class CalendarEntry {
  const CalendarEntry({
    required this.id,
    required this.type,
    required this.date,
    required this.title,
    this.endDate,
    this.time,
    this.details = const {},
    this.annual = false,
  });

  final String id;
  final CalendarEntryType type;
  final DateTime date;
  final DateTime? endDate;
  final String title;
  final TimeOfDay? time;
  final Map<String, String> details;
  final bool annual;

  bool occursOn(DateTime day) {
    if (annual) {
      return date.month == day.month && date.day == day.day;
    }

    final start = DateTime(date.year, date.month, date.day);
    final target = DateTime(day.year, day.month, day.day);
    final end = endDate == null
        ? start
        : DateTime(endDate!.year, endDate!.month, endDate!.day);

    return !target.isBefore(start) && !target.isAfter(end);
  }

  bool occursInMonth(DateTime month) {
    if (annual) return date.month == month.month;

    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 0);
    final start = DateTime(date.year, date.month, date.day);
    final end = endDate == null
        ? start
        : DateTime(endDate!.year, endDate!.month, endDate!.day);

    return !end.isBefore(monthStart) && !start.isAfter(monthEnd);
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({required this.setup, super.key});

  final CoupleSetup setup;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime visibleMonth;
  late DateTime selectedDate;
  CalendarEntryType? filter;
  late final List<CalendarEntry> entries;

  static const weekdays = ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB'];
  static const months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    visibleMonth = DateTime(now.year, now.month);
    selectedDate = DateTime(now.year, now.month, now.day);
    entries = _seedEntries();
  }

  String _seedId(String prefix, DateTime date) {
    return prefix +
        '-' +
        date.year.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.day.toString();
  }

  List<CalendarEntry> _seedEntries() {
    final result = <CalendarEntry>[];

    if (widget.setup.relationshipDate != null) {
      final date = widget.setup.relationshipDate!;
      result.add(
        CalendarEntry(
          id: _seedId('relationship', date),
          type: CalendarEntryType.special,
          date: date,
          title: 'Nossa data especial',
          details: {'Tipo': widget.setup.relationshipStatus},
          annual: true,
        ),
      );
    }

    if (widget.setup.userBirthday != null) {
      final date = widget.setup.userBirthday!;
      result.add(
        CalendarEntry(
          id: _seedId('birthday-user', date),
          type: CalendarEntryType.special,
          date: date,
          title: 'Aniversário de ' + widget.setup.userName,
          details: {'Repetição': 'Todos os anos'},
          annual: true,
        ),
      );
    }

    if (widget.setup.partnerBirthday != null) {
      final date = widget.setup.partnerBirthday!;
      result.add(
        CalendarEntry(
          id: _seedId('birthday-partner', date),
          type: CalendarEntryType.special,
          date: date,
          title: 'Aniversário de ' + widget.setup.partnerName,
          details: {'Repetição': 'Todos os anos'},
          annual: true,
        ),
      );
    }

    if (widget.setup.lastIntimacyDate != null) {
      final date = widget.setup.lastIntimacyDate!;
      result.add(
        CalendarEntry(
          id: _seedId('intimacy', date),
          type: CalendarEntryType.intimacy,
          date: date,
          title: 'Momento íntimo',
          details: const {'Conexão': 'Não informado'},
        ),
      );
    }

    return result;
  }

  List<CalendarEntry> get selectedEntries {
    final values = entries
        .where((entry) => entry.occursOn(selectedDate))
        .where((entry) => filter == null || entry.type == filter)
        .toList();

    values.sort((a, b) {
      final aMinutes = (a.time?.hour ?? 0) * 60 + (a.time?.minute ?? 0);
      final bMinutes = (b.time?.hour ?? 0) * 60 + (b.time?.minute ?? 0);
      return aMinutes.compareTo(bMinutes);
    });
    return values;
  }

  int _monthCount(CalendarEntryType type) {
    return entries
        .where((entry) => entry.type == type)
        .where((entry) => entry.occursInMonth(visibleMonth))
        .length;
  }

  void _changeMonth(int delta) {
    final next = DateTime(visibleMonth.year, visibleMonth.month + delta);
    setState(() {
      visibleMonth = next;
      selectedDate = DateTime(next.year, next.month, 1);
    });
  }

  void _goToday() {
    final now = DateTime.now();
    setState(() {
      visibleMonth = DateTime(now.year, now.month);
      selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  Future<CalendarEntry?> _openEditor({
    CalendarEntry? initial,
    CalendarEntryType? initialType,
  }) {
    return showModalBottomSheet<CalendarEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: TwinColors.ivory,
      builder: (context) => _EventEditor(
        date: initial?.date ?? selectedDate,
        initial: initial,
        initialType: initialType,
      ),
    );
  }

  Future<void> _addEntry([CalendarEntryType? type]) async {
    final entry = await _openEditor(initialType: type);
    if (entry == null || !mounted) return;

    setState(() {
      entries.add(entry);
      selectedDate = entry.date;
      visibleMonth = DateTime(entry.date.year, entry.date.month);
    });
  }

  Future<void> _editEntry(CalendarEntry entry) async {
    final updated = await _openEditor(initial: entry);
    if (updated == null || !mounted) return;

    final index = entries.indexWhere((item) => item.id == entry.id);
    if (index == -1) return;

    setState(() {
      entries[index] = updated;
      selectedDate = updated.date;
      visibleMonth = DateTime(updated.date.year, updated.date.month);
    });
  }

  Future<void> _deleteEntry(CalendarEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir registro?'),
        content: Text(
          '“' + entry.title + '” será removido do calendário.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFA34848),
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => entries.removeWhere((item) => item.id == entry.id));
  }

  Future<void> _openDetails(CalendarEntry entry) async {
    final action = await showModalBottomSheet<_EntryAction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: TwinColors.ivory,
      builder: (context) => _EntryDetails(entry: entry),
    );

    if (!mounted) return;
    if (action == _EntryAction.edit) {
      await _editEntry(entry);
    } else if (action == _EntryAction.delete) {
      await _deleteEntry(entry);
    }
  }

  CalendarEntry? get _cycleEntryForSelectedDay {
    for (final entry in entries.reversed) {
      if (entry.type == CalendarEntryType.cycle &&
          entry.occursOn(selectedDate)) {
        return entry;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cycleEntry = _cycleEntryForSelectedDay;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalendarHeader(
            onAdd: () => _addEntry(),
            onToday: _goToday,
          ),
          const SizedBox(height: 13),
          _MonthCard(
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            entries: entries,
            weekdays: weekdays,
            monthName: months[visibleMonth.month - 1],
            onPrevious: () => _changeMonth(-1),
            onNext: () => _changeMonth(1),
            onSelect: (date) => setState(() => selectedDate = date),
          ),
          const SizedBox(height: 10),
          _MonthSummary(
            fightCount: _monthCount(CalendarEntryType.fight),
            intimacyCount: _monthCount(CalendarEntryType.intimacy),
            specialCount: _monthCount(CalendarEntryType.special),
            cycleCount: _monthCount(CalendarEntryType.cycle),
          ),
          const SizedBox(height: 10),
          _FilterBar(
            selected: filter,
            onChanged: (value) => setState(() => filter = value),
          ),
          if (cycleEntry != null) ...[
            const SizedBox(height: 12),
            _CareTip(entry: cycleEntry),
          ],
          const SizedBox(height: 17),
          _DayHeading(date: selectedDate, count: selectedEntries.length),
          const SizedBox(height: 9),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: selectedEntries.isEmpty
                ? _EmptyDay(
                    key: ValueKey(
                      'empty-' +
                          selectedDate.toIso8601String() +
                          '-' +
                          filter.toString(),
                    ),
                    onAdd: () => _addEntry(),
                  )
                : Column(
                    key: ValueKey(
                      'events-' +
                          selectedDate.toIso8601String() +
                          '-' +
                          filter.toString() +
                          '-' +
                          selectedEntries.length.toString(),
                    ),
                    children: [
                      for (final entry in selectedEntries) ...[
                        _EventTile(
                          entry: entry,
                          onTap: () => _openDetails(entry),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: 10),
          _QuickAdd(onAdd: _addEntry),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.onAdd,
    required this.onToday,
  });

  final VoidCallback onAdd;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nosso calendário',
                style: GoogleFonts.cormorantGaramond(
                  color: TwinColors.ink,
                  fontSize: 30,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Datas, intimidade, ciclo e o que vocês viveram.',
                style: TextStyle(
                  color: TwinColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onToday,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            foregroundColor: TwinColors.burgundy,
          ),
          child: const Text(
            'Hoje',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 40,
          height: 40,
          child: IconButton.filled(
            onPressed: onAdd,
            style: IconButton.styleFrom(
              backgroundColor: TwinColors.burgundy,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }
}

class _MonthCard extends StatelessWidget {
  const _MonthCard({
    required this.visibleMonth,
    required this.selectedDate,
    required this.entries,
    required this.weekdays,
    required this.monthName,
    required this.onPrevious,
    required this.onNext,
    required this.onSelect,
  });

  final DateTime visibleMonth;
  final DateTime selectedDate;
  final List<CalendarEntry> entries;
  final List<String> weekdays;
  final String monthName;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final offset = first.weekday % 7;
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;

    return Container(
      padding: const EdgeInsets.fromLTRB(11, 8, 11, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: TwinColors.sand.withValues(alpha: .72),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  monthName + ' de ' + visibleMonth.year.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TwinColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            children: weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: TwinColors.muted,
                          fontSize: 8.2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 3),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.08,
            ),
            itemBuilder: (context, index) {
              final day = index - offset + 1;
              if (day < 1 || day > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                visibleMonth.year,
                visibleMonth.month,
                day,
              );
              final selected = _sameDay(date, selectedDate);
              final today = _sameDay(date, DateTime.now());
              final dayEntries =
                  entries.where((entry) => entry.occursOn(date)).toList();
              final colors =
                  dayEntries.map((entry) => entry.type.color).toSet().take(3);

              return InkWell(
                onTap: () => onSelect(date),
                customBorder: const CircleBorder(),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color:
                          selected ? TwinColors.burgundy : Colors.transparent,
                      shape: BoxShape.circle,
                      border: today && !selected
                          ? Border.all(color: TwinColors.terracotta)
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          day.toString(),
                          style: TextStyle(
                            color:
                                selected ? Colors.white : TwinColors.ink,
                            fontSize: 11,
                            fontWeight: selected || today
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                        if (colors.isNotEmpty)
                          Positioned(
                            bottom: 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final color in colors)
                                  Container(
                                    width: 3.5,
                                    height: 3.5,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: .8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          selected ? Colors.white : color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({
    required this.fightCount,
    required this.intimacyCount,
    required this.specialCount,
    required this.cycleCount,
  });

  final int fightCount;
  final int intimacyCount;
  final int specialCount;
  final int cycleCount;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Brigas', fightCount, CalendarEntryType.fight.color),
      ('Intimidade', intimacyCount, CalendarEntryType.intimacy.color),
      ('Especiais', specialCount, CalendarEntryType.special.color),
      ('Ciclo', cycleCount, CalendarEntryType.cycle.color),
    ];

    return SizedBox(
      height: 49,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            constraints: const BoxConstraints(minWidth: 82),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: TwinColors.sand.withValues(alpha: .7),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: item.$3,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.$2.toString(),
                      style: const TextStyle(
                        color: TwinColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      item.$1,
                      style: const TextStyle(
                        color: TwinColors.muted,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selected,
    required this.onChanged,
  });

  final CalendarEntryType? selected;
  final ValueChanged<CalendarEntryType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <CalendarEntryType?>[
      null,
      ...CalendarEntryType.values,
    ];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final type = options[index];
          final active = selected == type;
          final label = type?.label ?? 'Todos';

          return InkWell(
            onTap: () => onChanged(type),
            borderRadius: BorderRadius.circular(99),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: active ? TwinColors.burgundy : Colors.white,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color:
                      active ? TwinColors.burgundy : TwinColors.sand,
                ),
              ),
              child: Row(
                children: [
                  if (type != null) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: active ? Colors.white : type.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: active ? Colors.white : TwinColors.ink,
                      fontSize: 9.6,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CareTip extends StatelessWidget {
  const _CareTip({required this.entry});

  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    final symptom = entry.details['Sintomas'];
    final flow = entry.details['Fluxo'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8E9EE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: CalendarEntryType.cycle.color.withValues(alpha: .22),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.favorite_outline_rounded,
            color: Color(0xFF9C4965),
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Um pouco mais de carinho hoje',
                  style: TextStyle(
                    color: Color(0xFF6C3347),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Se fizer sentido para ela, atenção, descanso, uma flor ou um chocolatinho podem ser um gesto gostoso.' +
                      (symptom == null ? '' : ' Sintomas: ' + symptom + '.') +
                      (flow == null ? '' : ' Fluxo: ' + flow + '.'),
                  style: const TextStyle(
                    color: Color(0xFF83566A),
                    fontSize: 9.7,
                    height: 1.35,
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

class _DayHeading extends StatelessWidget {
  const _DayHeading({required this.date, required this.count});

  final DateTime date;
  final int count;

  @override
  Widget build(BuildContext context) {
    final countLabel = count == 0
        ? 'Nada registrado'
        : count.toString() + (count == 1 ? ' registro' : ' registros');

    return Row(
      children: [
        Expanded(
          child: Text(
            _dayLabel(date),
            style: const TextStyle(
              color: TwinColors.ink,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          countLabel,
          style: const TextStyle(
            color: TwinColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.entry, required this.onTap});

  final CalendarEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeLabel =
        entry.time == null ? '' : ' · ' + _formatTime(entry.time!);
    final intensity = entry.details['Intensidade'];
    final extra = entry.type == CalendarEntryType.fight && intensity != null
        ? ' · intensidade ' + intensity
        : '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(11, 10, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: TwinColors.sand.withValues(alpha: .72),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: entry.type.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                entry.type.icon,
                color: entry.type.color,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: TwinColors.ink,
                      fontSize: 11.8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.type.singular + timeLabel + extra,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: TwinColors.muted,
                      fontSize: 9.8,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: TwinColors.mocha,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: TwinColors.sand.withValues(alpha: .24),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: TwinColors.mocha,
            size: 23,
          ),
          const SizedBox(height: 6),
          const Text(
            'Esse dia ainda está em branco.',
            style: TextStyle(
              color: TwinColors.ink,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: onAdd,
            child: const Text(
              'Adicionar registro',
              style: TextStyle(fontSize: 10.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAdd extends StatelessWidget {
  const _QuickAdd({required this.onAdd});

  final ValueChanged<CalendarEntryType?> onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Adicionar rápido',
          style: TextStyle(
            color: TwinColors.muted,
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Expanded(
              child: _QuickButton(
                type: CalendarEntryType.fight,
                onTap: () => onAdd(CalendarEntryType.fight),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickButton(
                type: CalendarEntryType.intimacy,
                onTap: () => onAdd(CalendarEntryType.intimacy),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _QuickButton(
                type: CalendarEntryType.cycle,
                onTap: () => onAdd(CalendarEntryType.cycle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  const _QuickButton({
    required this.type,
    required this.onTap,
  });

  final CalendarEntryType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        decoration: BoxDecoration(
          color: type.color.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: type.color.withValues(alpha: .17),
          ),
        ),
        child: Column(
          children: [
            Icon(type.icon, size: 17, color: type.color),
            const SizedBox(height: 4),
            Text(
              type.singular,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: TwinColors.ink,
                fontSize: 8.8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventEditor extends StatefulWidget {
  const _EventEditor({
    required this.date,
    this.initial,
    this.initialType,
  });

  final DateTime date;
  final CalendarEntry? initial;
  final CalendarEntryType? initialType;

  @override
  State<_EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends State<_EventEditor> {
  late final TextEditingController title;
  late final TextEditingController reason;
  late final TextEditingController notes;

  late CalendarEntryType type;
  late DateTime date;
  DateTime? endDate;
  TimeOfDay time = TimeOfDay.now();
  bool hasTime = false;
  bool annual = false;

  int intensity = 2;
  String feeling = 'Chateação';
  String participation = 'Nós dois';
  String resolution = 'Conversamos e nos entendemos';
  String duration = '10–30 min';

  String connection = 'Boa';
  String cycleFlow = 'Médio';
  final Set<String> cycleSymptoms = {};
  String? error;

  bool get isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    type = initial?.type ?? widget.initialType ?? CalendarEntryType.special;
    date = initial?.date ?? widget.date;
    endDate = initial?.endDate;
    time = initial?.time ?? TimeOfDay.now();
    hasTime = initial?.time != null;
    annual = initial?.annual ?? false;

    title = TextEditingController(text: initial?.title ?? '');
    reason = TextEditingController(
      text: initial?.details['Motivo'] ?? '',
    );
    notes = TextEditingController(
      text: initial?.details['Observações'] ?? '',
    );

    intensity =
        _parseIntensity(initial?.details['Intensidade']) ?? 2;
    feeling = initial?.details['Sentimento'] ?? 'Chateação';
    participation =
        initial?.details['Participação'] ?? 'Nós dois';
    resolution = initial?.details['Resolução'] ??
        'Conversamos e nos entendemos';
    duration = initial?.details['Duração'] ?? '10–30 min';
    connection = initial?.details['Conexão'] ?? 'Boa';
    cycleFlow = initial?.details['Fluxo'] ?? 'Médio';

    final symptomText = initial?.details['Sintomas'];
    if (symptomText != null && symptomText != 'Nenhum informado') {
      cycleSymptoms.addAll(
        symptomText
            .split(', ')
            .where((value) => value.trim().isNotEmpty),
      );
    }
  }

  int? _parseIntensity(String? value) {
    if (value == null || value.isEmpty) return null;
    return int.tryParse(value.split('/').first);
  }

  @override
  void dispose() {
    title.dispose();
    reason.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate({bool end = false}) async {
    final value = await showDatePicker(
      context: context,
      initialDate: end ? (endDate ?? date) : date,
      firstDate: DateTime(1940),
      lastDate: DateTime(2100),
      helpText: end ? 'Fim do ciclo' : 'Data do registro',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (value == null) return;

    setState(() {
      if (end) {
        endDate = value.isBefore(date) ? date : value;
      } else {
        date = value;
        if (endDate != null && endDate!.isBefore(date)) {
          endDate = date;
        }
      }
    });
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (value != null) setState(() => time = value);
  }

  void _changeType(CalendarEntryType value) {
    setState(() {
      type = value;
      error = null;
      if (type == CalendarEntryType.cycle) {
        hasTime = false;
        annual = false;
      }
    });
  }

  void _save() {
    setState(() => error = null);

    if (type == CalendarEntryType.fight &&
        reason.text.trim().isEmpty) {
      setState(() {
        error = 'Conte resumidamente o que iniciou a discussão.';
      });
      return;
    }

    if ((type == CalendarEntryType.commitment ||
            type == CalendarEntryType.special) &&
        title.text.trim().isEmpty) {
      setState(() {
        error = 'Dê um nome para esse registro.';
      });
      return;
    }

    String autoTitle;
    switch (type) {
      case CalendarEntryType.fight:
        autoTitle = 'Desentendimento';
        break;
      case CalendarEntryType.special:
        autoTitle = 'Data especial';
        break;
      case CalendarEntryType.intimacy:
        autoTitle = 'Momento íntimo';
        break;
      case CalendarEntryType.commitment:
        autoTitle = 'Compromisso';
        break;
      case CalendarEntryType.cycle:
        autoTitle = 'Menstruação';
        break;
    }

    final details = <String, String>{};

    if (type == CalendarEntryType.fight) {
      details.addAll({
        'Motivo': reason.text.trim(),
        'Intensidade': intensity.toString() + '/3',
        'Sentimento': feeling,
        'Participação': participation,
        'Duração': duration,
        'Resolução': resolution,
      });
    } else if (type == CalendarEntryType.intimacy) {
      details['Conexão'] = connection;
    } else if (type == CalendarEntryType.cycle) {
      details['Fluxo'] = cycleFlow;
      details['Sintomas'] = cycleSymptoms.isEmpty
          ? 'Nenhum informado'
          : cycleSymptoms.join(', ');
    }

    if (notes.text.trim().isNotEmpty) {
      details['Observações'] = notes.text.trim();
    }

    if (annual && type == CalendarEntryType.special) {
      details['Repetição'] = 'Todos os anos';
    }

    Navigator.of(context).pop(
      CalendarEntry(
        id: widget.initial?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        type: type,
        date: date,
        endDate: type == CalendarEntryType.cycle ? endDate : null,
        title: title.text.trim().isEmpty
            ? autoTitle
            : title.text.trim(),
        time: hasTime && type != CalendarEntryType.cycle ? time : null,
        details: details,
        annual: type == CalendarEntryType.special && annual,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 16 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Editar registro' : 'Adicionar registro',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: TwinColors.ink,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              isEditing
                  ? 'Ajuste as informações desse momento.'
                  : 'Registre o que aconteceu nesse dia.',
              style: const TextStyle(
                color: TwinColors.muted,
                fontSize: 10.5,
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: CalendarEntryType.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 7),
                itemBuilder: (context, index) {
                  final item = CalendarEntryType.values[index];
                  final active = item == type;

                  return InkWell(
                    onTap: () => _changeType(item),
                    borderRadius: BorderRadius.circular(17),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: active ? item.color : Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(
                          color: active ? item.color : TwinColors.sand,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color: active ? Colors.white : item.color,
                            size: 19,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.singular,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : TwinColors.ink,
                              fontSize: 9.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _EditorDateRow(
              date: date,
              onTap: () => _pickDate(),
            ),
            if (type == CalendarEntryType.cycle) ...[
              const SizedBox(height: 8),
              _EditorDateRow(
                date: endDate,
                label: 'Fim do ciclo (opcional)',
                onTap: () => _pickDate(end: true),
              ),
            ],
            if (type != CalendarEntryType.cycle) ...[
              const SizedBox(height: 8),
              _TimeToggle(
                value: hasTime,
                time: time,
                onChanged: (value) => setState(() => hasTime = value),
                onPick: _pickTime,
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: type == CalendarEntryType.special ||
                        type == CalendarEntryType.commitment
                    ? 'Título'
                    : 'Título opcional',
                hintText: _titleHint(type),
              ),
            ),
            if (type == CalendarEntryType.special) ...[
              const SizedBox(height: 8),
              _SwitchLine(
                title: 'Repetir todos os anos',
                subtitle: 'Ideal para aniversários e datas do casal.',
                value: annual,
                onChanged: (value) => setState(() => annual = value),
              ),
            ],
            if (type == CalendarEntryType.fight) ...[
              const SizedBox(height: 14),
              const _EditorLabel(
                'Pensando com calma, o que fez isso começar?',
              ),
              const SizedBox(height: 7),
              TextField(
                controller: reason,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Descreva o motivo sem culpar ou atacar.',
                ),
              ),
              const SizedBox(height: 13),
              const _EditorLabel('Intensidade'),
              const SizedBox(height: 7),
              Row(
                children: [
                  for (final value in [1, 2, 3])
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: value == 3 ? 0 : 7,
                        ),
                        child: _MiniChoice(
                          label: value == 1
                              ? 'Leve'
                              : value == 2
                                  ? 'Média'
                                  : 'Forte',
                          selected: intensity == value,
                          color: value == 1
                              ? TwinColors.softGold
                              : value == 2
                                  ? TwinColors.terracotta
                                  : const Color(0xFFA34848),
                          onTap: () {
                            setState(() => intensity = value);
                          },
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 13),
              const _EditorLabel('O que você sentiu?'),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const [
                  'Raiva',
                  'Chateação',
                  'Tristeza',
                  'Não sei identificar',
                ],
                selected: feeling,
                onChanged: (value) {
                  setState(() => feeling = value);
                },
              ),
              const SizedBox(height: 13),
              const _EditorLabel(
                'Como você percebe a participação de vocês?',
              ),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const [
                  'Eu tive maior participação',
                  'Meu parceiro teve maior participação',
                  'Nós dois',
                  'Não consigo identificar',
                ],
                selected: participation,
                onChanged: (value) {
                  setState(() => participation = value);
                },
              ),
              const SizedBox(height: 13),
              const _EditorLabel('Quanto tempo durou?'),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const [
                  'Até 10 min',
                  '10–30 min',
                  '30–60 min',
                  'Mais de 1h',
                ],
                selected: duration,
                onChanged: (value) {
                  setState(() => duration = value);
                },
              ),
              const SizedBox(height: 13),
              const _EditorLabel(
                'Como a situação foi resolvida?',
              ),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const [
                  'Conversamos e nos entendemos',
                  'Cada um foi para um lado',
                  'Ainda não resolvemos',
                  'Não sei dizer',
                ],
                selected: resolution,
                onChanged: (value) {
                  setState(() => resolution = value);
                },
              ),
            ],
            if (type == CalendarEntryType.intimacy) ...[
              const SizedBox(height: 14),
              const _EditorLabel(
                'Como você percebeu a conexão entre vocês?',
              ),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const ['Muito boa', 'Boa', 'Neutra', 'Distante'],
                selected: connection,
                onChanged: (value) {
                  setState(() => connection = value);
                },
              ),
            ],
            if (type == CalendarEntryType.cycle) ...[
              const SizedBox(height: 14),
              const _EditorLabel('Fluxo'),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const ['Leve', 'Médio', 'Intenso'],
                selected: cycleFlow,
                onChanged: (value) {
                  setState(() => cycleFlow = value);
                },
              ),
              const SizedBox(height: 13),
              const _EditorLabel('Sintomas'),
              const SizedBox(height: 7),
              _MultiChoices(
                values: const [
                  'Cólica',
                  'Dor de cabeça',
                  'Cansaço',
                  'Sensibilidade',
                  'Irritabilidade',
                  'Inchaço',
                ],
                selected: cycleSymptoms,
                onToggle: (value) {
                  setState(() {
                    cycleSymptoms.contains(value)
                        ? cycleSymptoms.remove(value)
                        : cycleSymptoms.add(value);
                  });
                },
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: notes,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Observações',
                hintText: 'Algo que vocês queiram lembrar depois...',
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 9),
              Text(
                error!,
                style: const TextStyle(
                  color: TwinColors.burgundy,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 49,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  backgroundColor: TwinColors.burgundy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  isEditing
                      ? 'Salvar alterações'
                      : 'Salvar no calendário',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorDateRow extends StatelessWidget {
  const _EditorDateRow({
    required this.date,
    required this.onTap,
    this.label = 'Data',
  });

  final DateTime? date;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_month_outlined),
        ),
        child: Text(
          date == null ? 'Selecionar' : _formatDate(date!),
          style: TextStyle(
            color: date == null ? TwinColors.muted : TwinColors.ink,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TimeToggle extends StatelessWidget {
  const _TimeToggle({
    required this.value,
    required this.time,
    required this.onChanged,
    required this.onPick,
  });

  final bool value;
  final TimeOfDay time;
  final ValueChanged<bool> onChanged;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 7, 8, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: TwinColors.sand.withValues(alpha: .75),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: TwinColors.burgundy,
            size: 20,
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Text(
              'Adicionar horário',
              style: TextStyle(
                color: TwinColors.ink,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (value)
            TextButton(
              onPressed: onPick,
              child: Text(
                _formatTime(time),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: TwinColors.burgundy,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _SwitchLine extends StatelessWidget {
  const _SwitchLine({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: TwinColors.sand.withValues(alpha: .20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: TwinColors.ink,
                    fontSize: 10.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: TwinColors.muted,
                    fontSize: 9.2,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: TwinColors.burgundy,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _EditorLabel extends StatelessWidget {
  const _EditorLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: TwinColors.ink,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _WrapChoices extends StatelessWidget {
  const _WrapChoices({
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: values
          .map(
            (value) => _MiniChoice(
              label: value,
              selected: selected == value,
              color: TwinColors.burgundy,
              onTap: () => onChanged(value),
            ),
          )
          .toList(),
    );
  }
}

class _MultiChoices extends StatelessWidget {
  const _MultiChoices({
    required this.values,
    required this.selected,
    required this.onToggle,
  });

  final List<String> values;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: values
          .map(
            (value) => _MiniChoice(
              label: value,
              selected: selected.contains(value),
              color: CalendarEntryType.cycle.color,
              onTap: () => onToggle(value),
            ),
          )
          .toList(),
    );
  }
}

class _MiniChoice extends StatelessWidget {
  const _MiniChoice({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected ? color : TwinColors.sand,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : TwinColors.ink,
            fontSize: 9.3,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

enum _EntryAction { edit, delete }

class _EntryDetails extends StatelessWidget {
  const _EntryDetails({required this.entry});

  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    final timeLabel =
        entry.time == null ? '' : ' · ' + _formatTime(entry.time!);
    final endLabel = entry.endDate == null
        ? ''
        : ' até ' + _formatDate(entry.endDate!);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: entry.type.color.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    entry.type.icon,
                    color: entry.type.color,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 15,
                          color: TwinColors.ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        entry.type.singular +
                            ' · ' +
                            _formatDate(entry.date) +
                            endLabel +
                            timeLabel,
                        style: const TextStyle(
                          color: TwinColors.muted,
                          fontSize: 10.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (entry.details.isNotEmpty) ...[
              const SizedBox(height: 16),
              for (final item in entry.details.entries) ...[
                _DetailRow(
                  label: item.key,
                  value: item.value,
                ),
                const SizedBox(height: 7),
              ],
            ],
            if (entry.type == CalendarEntryType.fight) ...[
              const SizedBox(height: 5),
              const _NvcCard(),
            ],
            const SizedBox(height: 17),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(_EntryAction.edit);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(_EntryAction.delete);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFA34848),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 17),
                    label: const Text('Excluir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NvcCard extends StatelessWidget {
  const _NvcCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: TwinColors.sand.withValues(alpha: .25),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: TwinColors.burgundy,
                size: 17,
              ),
              SizedBox(width: 7),
              Text(
                'Próximo passo · comunicação não violenta',
                style: TextStyle(
                  color: TwinColors.ink,
                  fontSize: 10.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Text(
            'Tentem conversar em quatro partes: o que aconteceu sem julgamento, o que cada um sentiu, do que precisava e qual pedido concreto pode fazer agora.',
            style: TextStyle(
              color: TwinColors.muted,
              fontSize: 9.7,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    Color valueColor = TwinColors.ink;

    if (label == 'Sentimento') {
      if (value == 'Raiva') {
        valueColor = const Color(0xFFA34848);
      } else if (value == 'Chateação') {
        valueColor = const Color(0xFFC8953F);
      } else if (value == 'Tristeza') {
        valueColor = const Color(0xFF56749A);
      } else {
        valueColor = TwinColors.mocha;
      }
    }

    if (label == 'Participação' &&
        value == 'Meu parceiro teve maior participação') {
      valueColor = const Color(0xFF4C72A3);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: TwinColors.sand.withValues(alpha: .7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: TwinColors.muted,
              fontSize: 8.2,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 11.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String _titleHint(CalendarEntryType type) {
  switch (type) {
    case CalendarEntryType.fight:
      return 'Ex.: Discussão sobre horários';
    case CalendarEntryType.special:
      return 'Ex.: Aniversário de namoro';
    case CalendarEntryType.intimacy:
      return 'Ex.: Nossa noite';
    case CalendarEntryType.commitment:
      return 'Ex.: Jantar, cinema, viagem...';
    case CalendarEntryType.cycle:
      return 'Menstruação';
  }
}

bool _sameDay(DateTime a, DateTime b) {
  return a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
}

String _formatTime(TimeOfDay time) {
  return time.hour.toString().padLeft(2, '0') +
      ':' +
      time.minute.toString().padLeft(2, '0');
}

String _formatDate(DateTime date) {
  return date.day.toString().padLeft(2, '0') +
      '/' +
      date.month.toString().padLeft(2, '0') +
      '/' +
      date.year.toString();
}

String _dayLabel(DateTime date) {
  const names = [
    'domingo',
    'segunda-feira',
    'terça-feira',
    'quarta-feira',
    'quinta-feira',
    'sexta-feira',
    'sábado',
  ];
  final weekIndex = date.weekday % 7;
  return names[weekIndex] +
      ', ' +
      date.day.toString().padLeft(2, '0') +
      '/' +
      date.month.toString().padLeft(2, '0');
}
