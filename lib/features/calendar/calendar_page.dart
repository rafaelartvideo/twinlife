import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/features/onboarding/couple_setup.dart';

enum CalendarEntryType {
  fight,
  disagreement,
  special,
  intimacy,
  commitment,
  cycle,
}

extension CalendarEntryTypeUi on CalendarEntryType {
  String get label {
    switch (this) {
      case CalendarEntryType.fight:
        return 'Brigas';
      case CalendarEntryType.disagreement:
        return 'Desentendimentos';
      case CalendarEntryType.special:
        return 'Especiais';
      case CalendarEntryType.intimacy:
        return 'Intimidade';
      case CalendarEntryType.commitment:
        return 'Compromissos';
      case CalendarEntryType.cycle:
        return 'Fluxo menstrual';
    }
  }

  String get singular {
    switch (this) {
      case CalendarEntryType.fight:
        return 'Briga';
      case CalendarEntryType.disagreement:
        return 'Desentendimento';
      case CalendarEntryType.special:
        return 'Momento especial';
      case CalendarEntryType.intimacy:
        return 'Momento íntimo';
      case CalendarEntryType.commitment:
        return 'Compromisso';
      case CalendarEntryType.cycle:
        return 'Fluxo menstrual';
    }
  }

  IconData get icon {
    switch (this) {
      case CalendarEntryType.fight:
        return Icons.flash_on_rounded;
      case CalendarEntryType.disagreement:
        return Icons.chat_bubble_outline_rounded;
      case CalendarEntryType.special:
        return Icons.favorite_rounded;
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
        return TwinColors.fightRed;
      case CalendarEntryType.disagreement:
        return TwinColors.disagreementYellow;
      case CalendarEntryType.special:
        return TwinColors.specialBlue;
      case CalendarEntryType.intimacy:
        return TwinColors.intimacyPink;
      case CalendarEntryType.commitment:
        return TwinColors.mocha;
      case CalendarEntryType.cycle:
        return TwinColors.cycleGray;
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
    final finish = endDate == null
        ? start
        : DateTime(endDate!.year, endDate!.month, endDate!.day);

    return !target.isBefore(start) && !target.isAfter(finish);
  }

  bool occursInMonth(DateTime month) {
    if (annual) return date.month == month.month;

    final startMonth = DateTime(month.year, month.month, 1);
    final endMonth = DateTime(month.year, month.month + 1, 0);
    final start = DateTime(date.year, date.month, date.day);
    final finish = endDate == null
        ? start
        : DateTime(endDate!.year, endDate!.month, endDate!.day);

    return !finish.isBefore(startMonth) && !start.isAfter(endMonth);
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
          details: {
            'Tipo': widget.setup.relationshipStatus,
            'Repetição': 'Todos os anos',
          },
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
          details: const {'Repetição': 'Todos os anos'},
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
          details: const {'Repetição': 'Todos os anos'},
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
          details: const {
            'Conexão': 'Não informado',
            'Proteção': 'Não informado',
          },
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

  DateTime? get _latestIntimacyDate {
    final dates = entries
        .where((entry) => entry.type == CalendarEntryType.intimacy)
        .map((entry) => entry.date)
        .toList();

    if (dates.isEmpty) return null;
    dates.sort();
    return dates.last;
  }

  int? get _daysWithoutIntimacy {
    if (!widget.setup.sexLifeActive) return null;
    final latest = _latestIntimacyDate;
    if (latest == null) return null;

    final today = DateTime.now();
    final cleanToday = DateTime(today.year, today.month, today.day);
    final cleanLatest = DateTime(latest.year, latest.month, latest.day);
    final days = cleanToday.difference(cleanLatest).inDays;

    return days >= 14 ? days : null;
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
        content: Text('“' + entry.title + '” será removido do calendário.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: TwinColors.fightRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      entries.removeWhere((item) => item.id == entry.id);
    });
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
    final daysWithoutIntimacy = _daysWithoutIntimacy;

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
            fights: _monthCount(CalendarEntryType.fight),
            disagreements: _monthCount(CalendarEntryType.disagreement),
            intimacy: _monthCount(CalendarEntryType.intimacy),
            cycle: _monthCount(CalendarEntryType.cycle),
            specials: _monthCount(CalendarEntryType.special),
          ),
          const SizedBox(height: 10),
          _FilterBar(
            selected: filter,
            onChanged: (value) => setState(() => filter = value),
          ),
          if (daysWithoutIntimacy != null) ...[
            const SizedBox(height: 12),
            _ConnectionTip(days: daysWithoutIntimacy),
          ],
          if (cycleEntry != null) ...[
            const SizedBox(height: 12),
            _CareTip(entry: cycleEntry),
          ],
          const SizedBox(height: 17),
          _DayHeading(
            date: selectedDate,
            count: selectedEntries.length,
          ),
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
                  fontSize: 29,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tudo que faz parte da história de vocês.',
                style: TextStyle(
                  color: TwinColors.muted,
                  fontSize: TwinType.body,
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
              fontSize: TwinType.body,
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
                    fontSize: TwinType.title,
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
                          fontSize: TwinType.caption,
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
              childAspectRatio: 1.02,
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
              final types = entries
                  .where((entry) => entry.occursOn(date))
                  .map((entry) => entry.type)
                  .toSet()
                  .take(3)
                  .toList();

              return InkWell(
                onTap: () => onSelect(date),
                customBorder: const CircleBorder(),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 38,
                    height: 38,
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
                        Positioned(
                          top: 7,
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              color:
                                  selected ? Colors.white : TwinColors.ink,
                              fontSize: 11.5,
                              fontWeight: selected || today
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (types.isNotEmpty)
                          Positioned(
                            left: 2,
                            right: 2,
                            bottom: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (final type in types)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: .7,
                                    ),
                                    child: _CalendarMarker(
                                      type: type,
                                      selected: selected,
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

class _CalendarMarker extends StatelessWidget {
  const _CalendarMarker({
    required this.type,
    required this.selected,
  });

  final CalendarEntryType type;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (type == CalendarEntryType.intimacy) {
      return Text(
        '❤️‍🔥',
        style: TextStyle(
          fontSize: 7.5,
          color: selected ? Colors.white : null,
          height: 1,
        ),
      );
    }

    final color = selected ? Colors.white : type.color;

    if (type == CalendarEntryType.fight) {
      return Icon(
        Icons.flash_on_rounded,
        size: 7.5,
        color: color,
      );
    }

    if (type == CalendarEntryType.disagreement) {
      return Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.remove_rounded,
          size: 5,
          color: selected
              ? TwinColors.burgundy
              : const Color(0xFF6D5411),
        ),
      );
    }

    return Icon(
      type.icon,
      size: 7.2,
      color: color,
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({
    required this.fights,
    required this.disagreements,
    required this.intimacy,
    required this.cycle,
    required this.specials,
  });

  final int fights;
  final int disagreements;
  final int intimacy;
  final int cycle;
  final int specials;

  @override
  Widget build(BuildContext context) {
    final items = [
      _SummaryItem('Brigas', fights, CalendarEntryType.fight.color),
      _SummaryItem(
        'Desent.',
        disagreements,
        CalendarEntryType.disagreement.color,
      ),
      _SummaryItem(
        'Intimidade',
        intimacy,
        CalendarEntryType.intimacy.color,
      ),
      _SummaryItem('Fluxo', cycle, CalendarEntryType.cycle.color),
      _SummaryItem(
        'Especiais',
        specials,
        CalendarEntryType.special.color,
      ),
    ];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final item = items[index];

          return Container(
            constraints: const BoxConstraints(minWidth: 86),
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
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
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.count.toString(),
                      style: const TextStyle(
                        color: TwinColors.ink,
                        fontSize: TwinType.title,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: TwinColors.muted,
                        fontSize: TwinType.caption,
                        fontWeight: FontWeight.w700,
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

class _SummaryItem {
  const _SummaryItem(this.label, this.count, this.color);

  final String label;
  final int count;
  final Color color;
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
      height: 38,
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
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: active ? TwinColors.burgundy : Colors.white,
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: active
                      ? TwinColors.burgundy
                      : TwinColors.sand,
                ),
              ),
              child: Row(
                children: [
                  if (type != null) ...[
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: active ? Colors.white : type.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: active ? Colors.white : TwinColors.ink,
                      fontSize: TwinType.caption,
                      fontWeight: FontWeight.w800,
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

class _ConnectionTip extends StatelessWidget {
  const _ConnectionTip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: TwinColors.intimacyPink.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: TwinColors.intimacyPink.withValues(alpha: .2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '❤️‍🔥',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Que tal criar um momento de conexão?',
                  style: TextStyle(
                    color: TwinColors.ink,
                    fontSize: TwinType.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Já faz ' +
                      days.toString() +
                      ' dias desde o último momento íntimo registrado. Pode ser carinho, conversa, passeio ou intimidade — sem pressão.',
                  style: const TextStyle(
                    color: TwinColors.muted,
                    fontSize: TwinType.body,
                    height: 1.4,
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

class _CareTip extends StatelessWidget {
  const _CareTip({required this.entry});

  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    final feelings = entry.details['Como se sente'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: TwinColors.cycleGray.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: TwinColors.cycleGray.withValues(alpha: .18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.favorite_outline_rounded,
            color: TwinColors.cycleGray,
            size: 20,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Um pouco mais de cuidado hoje',
                  style: TextStyle(
                    color: TwinColors.ink,
                    fontSize: TwinType.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Se fizer sentido para ela, carinho, atenção, descanso, flores ou um chocolatinho podem ser um gesto gostoso.' +
                      (feelings == null
                          ? ''
                          : ' Hoje ela registrou: ' + feelings + '.'),
                  style: const TextStyle(
                    color: TwinColors.muted,
                    fontSize: TwinType.body,
                    height: 1.4,
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
  const _DayHeading({
    required this.date,
    required this.count,
  });

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
              fontSize: TwinType.title,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          countLabel,
          style: const TextStyle(
            color: TwinColors.muted,
            fontSize: TwinType.caption,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({
    required this.entry,
    required this.onTap,
  });

  final CalendarEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeLabel =
        entry.time == null ? '' : ' · ' + _formatTime(entry.time!);
    final intensity = entry.details['Intensidade'];
    final extra = (entry.type == CalendarEntryType.fight ||
                entry.type == CalendarEntryType.disagreement) &&
            intensity != null
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: entry.type.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: entry.type == CalendarEntryType.intimacy
                  ? const Text(
                      '❤️‍🔥',
                      style: TextStyle(fontSize: 17),
                    )
                  : Icon(
                      entry.type.icon,
                      color: entry.type.color,
                      size: 19,
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
                      fontSize: TwinType.title,
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
                      fontSize: TwinType.caption,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: TwinColors.mocha,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({
    required this.onAdd,
    super.key,
  });

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
          const SizedBox(height: 7),
          const Text(
            'Esse dia ainda está em branco.',
            style: TextStyle(
              color: TwinColors.ink,
              fontSize: TwinType.body,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: onAdd,
            child: const Text('Adicionar registro'),
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
    final types = [
      CalendarEntryType.fight,
      CalendarEntryType.disagreement,
      CalendarEntryType.intimacy,
      CalendarEntryType.cycle,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ADICIONAR RÁPIDO',
          style: TextStyle(
            color: TwinColors.muted,
            fontSize: TwinType.caption,
            fontWeight: FontWeight.w800,
            letterSpacing: .7,
          ),
        ),
        const SizedBox(height: 7),
        SizedBox(
          height: 66,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(width: 7),
            itemBuilder: (context, index) {
              final type = types[index];

              return _QuickButton(
                type: type,
                onTap: () => onAdd(type),
              );
            },
          ),
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
        width: 96,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: type.color.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: type.color.withValues(alpha: .17),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            type == CalendarEntryType.intimacy
                ? const Text(
                    '❤️‍🔥',
                    style: TextStyle(fontSize: 17),
                  )
                : Icon(
                    type.icon,
                    size: 18,
                    color: type.color,
                  ),
            const SizedBox(height: 4),
            Text(
              type.singular,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: TwinColors.ink,
                fontSize: TwinType.caption,
                fontWeight: FontWeight.w800,
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
  late final TextEditingController timeText;

  late CalendarEntryType type;
  late DateTime date;
  DateTime? endDate;
  bool annual = false;

  double intensity = 2;
  String feeling = 'Chateação';
  String participation = 'Nós dois';
  String resolution = 'Conversamos e nos entendemos';

  String connection = 'Boa';
  String protection = 'Prefiro não informar';
  String afterIntimacy = 'Bem';
  String cycleFlow = 'Médio';
  final Set<String> cycleFeelings = {};

  String? error;

  bool get isEditing => widget.initial != null;

  bool get isConflict {
    return type == CalendarEntryType.fight ||
        type == CalendarEntryType.disagreement;
  }

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;
    type = initial?.type ?? widget.initialType ?? CalendarEntryType.special;
    date = initial?.date ?? widget.date;
    endDate = initial?.endDate;
    annual = initial?.annual ?? false;

    title = TextEditingController(text: initial?.title ?? '');
    reason = TextEditingController(
      text: initial?.details['Motivo'] ?? '',
    );
    notes = TextEditingController(
      text: initial?.details['Observações'] ?? '',
    );
    timeText = TextEditingController(
      text: initial?.time == null ? '' : _formatTime(initial!.time!),
    );

    intensity =
        (_parseIntensity(initial?.details['Intensidade']) ?? 2).toDouble();

    if (initial?.details['Sentimento'] != null) {
      feeling = initial!.details['Sentimento']!;
    } else {
      feeling = type == CalendarEntryType.fight
          ? 'Raiva'
          : 'Chateação';
    }

    participation =
        initial?.details['Participação'] ?? 'Nós dois';
    resolution = initial?.details['Resolução'] ??
        'Conversamos e nos entendemos';

    connection = initial?.details['Conexão'] ?? 'Boa';
    protection =
        initial?.details['Proteção'] ?? 'Prefiro não informar';
    afterIntimacy = initial?.details['Depois'] ?? 'Bem';

    cycleFlow = initial?.details['Fluxo'] ?? 'Médio';

    final feelings = initial?.details['Como se sente'];
    if (feelings != null && feelings != 'Não informado') {
      cycleFeelings.addAll(
        feelings
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
    timeText.dispose();
    super.dispose();
  }

  Future<void> _pickDate({bool end = false}) async {
    final value = await showDatePicker(
      context: context,
      initialDate: end ? (endDate ?? date) : date,
      firstDate: DateTime(1940),
      lastDate: DateTime(2100),
      helpText: end ? 'Fim do fluxo menstrual' : 'Data do registro',
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

  TimeOfDay? _readTime() {
    final raw = timeText.text.trim();
    if (raw.isEmpty) return null;

    final match = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').firstMatch(raw);
    if (match == null) return null;

    return TimeOfDay(
      hour: int.parse(match.group(1)!),
      minute: int.parse(match.group(2)!),
    );
  }

  void _changeType(CalendarEntryType value) {
    setState(() {
      type = value;
      error = null;

      if (value == CalendarEntryType.fight) {
        feeling = 'Raiva';
      } else if (value == CalendarEntryType.disagreement) {
        feeling = 'Chateação';
      }

      if (value == CalendarEntryType.cycle) {
        annual = false;
        timeText.clear();
      }
    });
  }

  void _save() {
    setState(() => error = null);

    if (isConflict && reason.text.trim().isEmpty) {
      setState(() {
        error = 'Conte resumidamente o que iniciou a situação.';
      });
      return;
    }

    if ((type == CalendarEntryType.special ||
            type == CalendarEntryType.commitment) &&
        title.text.trim().isEmpty) {
      setState(() {
        error = 'Dê um nome para esse registro.';
      });
      return;
    }

    TimeOfDay? parsedTime;

    if (type != CalendarEntryType.cycle &&
        timeText.text.trim().isNotEmpty) {
      parsedTime = _readTime();

      if (parsedTime == null) {
        setState(() {
          error = 'Digite o horário no formato 20:30.';
        });
        return;
      }
    }

    String autoTitle;

    switch (type) {
      case CalendarEntryType.fight:
        autoTitle = 'Briga';
        break;
      case CalendarEntryType.disagreement:
        autoTitle = 'Desentendimento';
        break;
      case CalendarEntryType.special:
        autoTitle = 'Momento especial';
        break;
      case CalendarEntryType.intimacy:
        autoTitle = 'Momento íntimo';
        break;
      case CalendarEntryType.commitment:
        autoTitle = 'Compromisso';
        break;
      case CalendarEntryType.cycle:
        autoTitle = 'Fluxo menstrual';
        break;
    }

    final details = <String, String>{};

    if (isConflict) {
      details.addAll({
        'Motivo': reason.text.trim(),
        'Intensidade': intensity.round().toString() + '/3',
        'Sentimento': feeling,
        'Participação': participation,
        'Resolução': resolution,
      });
    } else if (type == CalendarEntryType.intimacy) {
      details.addAll({
        'Conexão': connection,
        'Proteção': protection,
        'Depois': afterIntimacy,
      });
    } else if (type == CalendarEntryType.cycle) {
      details['Fluxo'] = cycleFlow;
      details['Como se sente'] = cycleFeelings.isEmpty
          ? 'Não informado'
          : cycleFeelings.join(', ');
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
        time: parsedTime,
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
            const SizedBox(height: 4),
            Text(
              _formatDate(date),
              style: const TextStyle(
                color: TwinColors.muted,
                fontSize: TwinType.body,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 72,
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
                      width: 91,
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
                          item == CalendarEntryType.intimacy
                              ? const Text(
                                  '❤️‍🔥',
                                  style: TextStyle(fontSize: 18),
                                )
                              : Icon(
                                  item.icon,
                                  color: active
                                      ? Colors.white
                                      : item.color,
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
                              fontSize: TwinType.caption,
                              fontWeight: FontWeight.w800,
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
                label: 'Fim do fluxo (opcional)',
                onTap: () => _pickDate(end: true),
              ),
            ] else ...[
              const SizedBox(height: 8),
              TextField(
                controller: timeText,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9:]'),
                  ),
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: const InputDecoration(
                  labelText: 'Horário (opcional)',
                  hintText: 'Ex.: 20:30',
                ),
              ),
            ],
            const SizedBox(height: 9),
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
              const SizedBox(height: 9),
              _SwitchLine(
                title: 'Repetir todos os anos',
                value: annual,
                onChanged: (value) => setState(() => annual = value),
              ),
            ],
            if (isConflict) ...[
              const SizedBox(height: 15),
              const _EditorLabel(
                'Pensando com calma, o que fez essa situação começar?',
              ),
              const SizedBox(height: 7),
              TextField(
                controller: reason,
                minLines: 2,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Conte de forma curta e sem julgamentos.',
                ),
              ),
              const SizedBox(height: 15),
              _IntensitySlider(
                value: intensity,
                onChanged: (value) => setState(() => intensity = value),
              ),
              const SizedBox(height: 15),
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
                onChanged: (value) => setState(() => feeling = value),
              ),
              const SizedBox(height: 15),
              const _EditorLabel(
                'Olhando agora com calma, como você percebe a participação de cada um?',
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
              const SizedBox(height: 15),
              const _EditorLabel('Como a situação foi resolvida?'),
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
              const SizedBox(height: 15),
              const _EditorLabel(
                'Como estava a conexão entre vocês?',
              ),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const [
                  'Muito boa',
                  'Boa',
                  'Neutra',
                  'Distante',
                ],
                selected: connection,
                onChanged: (value) {
                  setState(() => connection = value);
                },
              ),
              const SizedBox(height: 15),
              const _EditorLabel('Proteção'),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const [
                  'Com proteção',
                  'Sem proteção',
                  'Não se aplica',
                  'Prefiro não informar',
                ],
                selected: protection,
                onChanged: (value) {
                  setState(() => protection = value);
                },
              ),
              const SizedBox(height: 15),
              const _EditorLabel('Como você se sentiu depois?'),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const [
                  'Muito bem',
                  'Bem',
                  'Neutro',
                  'Desconfortável',
                ],
                selected: afterIntimacy,
                onChanged: (value) {
                  setState(() => afterIntimacy = value);
                },
              ),
            ],
            if (type == CalendarEntryType.cycle) ...[
              const SizedBox(height: 15),
              const _EditorLabel('Fluxo'),
              const SizedBox(height: 7),
              _WrapChoices(
                values: const ['Leve', 'Médio', 'Intenso'],
                selected: cycleFlow,
                onChanged: (value) {
                  setState(() => cycleFlow = value);
                },
                color: TwinColors.cycleGray,
              ),
              const SizedBox(height: 15),
              const _EditorLabel(
                'Como você está se sentindo hoje?',
              ),
              const SizedBox(height: 7),
              _MultiChoices(
                values: const [
                  'Cólica',
                  'Dor de cabeça',
                  'Cansaço',
                  'Sensível',
                  'Irritada',
                  'Inchada',
                  'Tranquila',
                  'Carente',
                ],
                selected: cycleFeelings,
                onToggle: (value) {
                  setState(() {
                    cycleFeelings.contains(value)
                        ? cycleFeelings.remove(value)
                        : cycleFeelings.add(value);
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
                  fontSize: TwinType.caption,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
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
                    fontSize: TwinType.body,
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

class _IntensitySlider extends StatelessWidget {
  const _IntensitySlider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  Color get color {
    if (value < 1.5) return TwinColors.softGold;
    if (value < 2.5) return TwinColors.terracotta;
    return TwinColors.fightRed;
  }

  String get label {
    if (value < 1.5) return 'Leve';
    if (value < 2.5) return 'Média';
    return 'Forte';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _EditorLabel('Intensidade'),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: TwinColors.sand,
            thumbColor: color,
            overlayColor: color.withValues(alpha: .12),
            trackHeight: 5,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 9,
            ),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 3,
            divisions: 2,
            onChanged: onChanged,
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Leve',
                style: TextStyle(
                  color: TwinColors.muted,
                  fontSize: TwinType.caption,
                ),
              ),
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: TwinType.body,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Expanded(
              child: Text(
                'Forte',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: TwinColors.muted,
                  fontSize: TwinType.caption,
                ),
              ),
            ),
          ],
        ),
      ],
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: TwinColors.sand.withValues(alpha: .8),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: TwinColors.mocha,
                fontSize: TwinType.caption,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date == null ? 'DD / MM / AAAA' : _formatDate(date!),
              style: TextStyle(
                color:
                    date == null ? TwinColors.muted : TwinColors.ink,
                fontSize: TwinType.input,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchLine extends StatelessWidget {
  const _SwitchLine({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 7, 8, 7),
      decoration: BoxDecoration(
        color: TwinColors.sand.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: TwinColors.ink,
                fontSize: TwinType.body,
                fontWeight: FontWeight.w700,
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

class _EditorLabel extends StatelessWidget {
  const _EditorLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: TwinColors.ink,
        fontSize: TwinType.title,
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
    this.color = TwinColors.burgundy,
  });

  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: values
          .map(
            (value) => _MiniChoice(
              label: value,
              selected: selected == value,
              color: color,
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
      spacing: 7,
      runSpacing: 7,
      children: values
          .map(
            (value) => _MiniChoice(
              label: value,
              selected: selected.contains(value),
              color: TwinColors.cycleGray,
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
          horizontal: 11,
          vertical: 9,
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
            fontSize: TwinType.body,
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

  bool get isConflict {
    return entry.type == CalendarEntryType.fight ||
        entry.type == CalendarEntryType.disagreement;
  }

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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: entry.type.color.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  alignment: Alignment.center,
                  child: entry.type == CalendarEntryType.intimacy
                      ? const Text(
                          '❤️‍🔥',
                          style: TextStyle(fontSize: 19),
                        )
                      : Icon(
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
                          fontSize: TwinType.title,
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
                          fontSize: TwinType.caption,
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
            if (isConflict) ...[
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
                      foregroundColor: TwinColors.fightRed,
                    ),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 17,
                    ),
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
                size: 18,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Comunicação não violenta',
                  style: TextStyle(
                    color: TwinColors.ink,
                    fontSize: TwinType.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Text(
            'Tentem separar a conversa em quatro partes: o que aconteceu sem julgamento, o que cada um sentiu, do que precisava e qual pedido concreto pode fazer agora.',
            style: TextStyle(
              color: TwinColors.muted,
              fontSize: TwinType.body,
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
        valueColor = TwinColors.fightRed;
      } else if (value == 'Chateação') {
        valueColor = const Color(0xFFB88A1A);
      } else if (value == 'Tristeza') {
        valueColor = TwinColors.specialBlue;
      } else {
        valueColor = TwinColors.mocha;
      }
    }

    if (label == 'Participação' &&
        value == 'Meu parceiro teve maior participação') {
      valueColor = TwinColors.specialBlue;
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
              fontSize: TwinType.caption,
              fontWeight: FontWeight.w800,
              letterSpacing: .7,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: TwinType.body,
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
      return 'Ex.: Briga por horários';
    case CalendarEntryType.disagreement:
      return 'Ex.: Ficamos chateados';
    case CalendarEntryType.special:
      return 'Ex.: Aniversário de namoro';
    case CalendarEntryType.intimacy:
      return 'Ex.: Nossa noite';
    case CalendarEntryType.commitment:
      return 'Ex.: Jantar, cinema, viagem...';
    case CalendarEntryType.cycle:
      return 'Fluxo menstrual';
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

  final index = date.weekday % 7;

  return names[index] +
      ', ' +
      date.day.toString().padLeft(2, '0') +
      '/' +
      date.month.toString().padLeft(2, '0');
}
