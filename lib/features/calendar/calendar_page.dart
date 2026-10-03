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
    required this.type,
    required this.date,
    required this.title,
    this.time,
    this.details = const {},
    this.annual = false,
  });

  final CalendarEntryType type;
  final DateTime date;
  final String title;
  final TimeOfDay? time;
  final Map<String, String> details;
  final bool annual;

  bool occursOn(DateTime day) {
    if (annual) {
      return date.month == day.month && date.day == day.day;
    }
    return date.year == day.year &&
        date.month == day.month &&
        date.day == day.day;
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

  List<CalendarEntry> _seedEntries() {
    final result = <CalendarEntry>[];

    if (widget.setup.relationshipDate != null) {
      result.add(
        CalendarEntry(
          type: CalendarEntryType.special,
          date: widget.setup.relationshipDate!,
          title: 'Nossa data especial',
          details: {'Tipo': widget.setup.relationshipStatus},
          annual: true,
        ),
      );
    }

    if (widget.setup.userBirthday != null) {
      result.add(
        CalendarEntry(
          type: CalendarEntryType.special,
          date: widget.setup.userBirthday!,
          title: 'Aniversário de ' + widget.setup.userName,
          annual: true,
        ),
      );
    }

    if (widget.setup.partnerBirthday != null) {
      result.add(
        CalendarEntry(
          type: CalendarEntryType.special,
          date: widget.setup.partnerBirthday!,
          title: 'Aniversário de ' + widget.setup.partnerName,
          annual: true,
        ),
      );
    }

    if (widget.setup.lastIntimacyDate != null) {
      result.add(
        CalendarEntry(
          type: CalendarEntryType.intimacy,
          date: widget.setup.lastIntimacyDate!,
          title: 'Momento íntimo',
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

  void _changeMonth(int delta) {
    final next = DateTime(visibleMonth.year, visibleMonth.month + delta);
    setState(() {
      visibleMonth = next;
      selectedDate = DateTime(next.year, next.month, 1);
    });
  }

  Future<void> _addEntry() async {
    final entry = await showModalBottomSheet<CalendarEntry>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: TwinColors.ivory,
      builder: (context) => _EventEditor(date: selectedDate),
    );

    if (entry == null || !mounted) return;
    setState(() => entries.add(entry));
  }

  void _openDetails(CalendarEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: TwinColors.ivory,
      builder: (context) => _EntryDetails(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CalendarHeader(onAdd: _addEntry),
          const SizedBox(height: 14),
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
          const SizedBox(height: 12),
          _FilterBar(
            selected: filter,
            onChanged: (value) => setState(() => filter = value),
          ),
          const SizedBox(height: 18),
          _DayHeading(date: selectedDate, count: selectedEntries.length),
          const SizedBox(height: 10),
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
                    onAdd: _addEntry,
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
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.onAdd});

  final VoidCallback onAdd;

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
                'A história de vocês, dia por dia.',
                style: TextStyle(
                  color: TwinColors.muted,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 42,
          height: 42,
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
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
                    fontSize: 12.5,
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
          const SizedBox(height: 3),
          Row(
            children: weekdays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: TwinColors.muted,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 5),
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
                    width: 37,
                    height: 37,
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
                            fontSize: 11.5,
                            fontWeight: selected || today
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                        if (colors.isNotEmpty)
                          Positioned(
                            bottom: 3,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final color in colors)
                                  Container(
                                    width: 4,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1,
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
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
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
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: active ? Colors.white : TwinColors.ink,
                      fontSize: 10,
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
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          countLabel,
          style: const TextStyle(
            color: TwinColors.muted,
            fontSize: 10.5,
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 11, 11, 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: TwinColors.sand.withValues(alpha: .72),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: entry.type.color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                entry.type.icon,
                color: entry.type.color,
                size: 19,
              ),
            ),
            const SizedBox(width: 11),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.type.label + timeLabel,
                    style: const TextStyle(
                      color: TwinColors.muted,
                      fontSize: 10.5,
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
  const _EmptyDay({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 22,
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        color: TwinColors.sand.withValues(alpha: .24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: TwinColors.mocha,
            size: 25,
          ),
          const SizedBox(height: 8),
          const Text(
            'Esse dia ainda está em branco.',
            style: TextStyle(
              color: TwinColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onAdd,
            child: const Text('Adicionar ao calendário'),
          ),
        ],
      ),
    );
  }
}

class _EventEditor extends StatefulWidget {
  const _EventEditor({required this.date});

  final DateTime date;

  @override
  State<_EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends State<_EventEditor> {
  final title = TextEditingController();
  final reason = TextEditingController();

  CalendarEntryType type = CalendarEntryType.special;
  TimeOfDay time = TimeOfDay.now();
  int intensity = 2;
  String feeling = 'Chateação';
  String participation = 'Nós dois';
  String resolution = 'Conversamos e nos entendemos';
  String duration = '10–30 min';
  String? error;

  @override
  void dispose() {
    title.dispose();
    reason.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (value != null) {
      setState(() => time = value);
    }
  }

  void _save() {
    if (type == CalendarEntryType.fight &&
        reason.text.trim().isEmpty) {
      setState(() {
        error = 'Conte resumidamente o motivo da discussão.';
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
        autoTitle = 'Ciclo menstrual';
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
    }

    Navigator.of(context).pop(
      CalendarEntry(
        type: type,
        date: widget.date,
        title: title.text.trim().isEmpty
            ? autoTitle
            : title.text.trim(),
        time: time,
        details: details,
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
              'Adicionar registro',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: TwinColors.ink,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _dayLabel(widget.date),
              style: const TextStyle(
                color: TwinColors.muted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: CalendarEntryType.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = CalendarEntryType.values[index];
                  final active = item == type;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        type = item;
                        error = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 82,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: active ? item.color : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: active ? item.color : TwinColors.sand,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color:
                                active ? Colors.white : item.color,
                            size: 20,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.label,
                            maxLines: 1,
                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : TwinColors.ink,
                              fontSize: 9.5,
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
            TextField(
              controller: title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Título opcional',
                hintText: 'Ex.: Nosso jantar',
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(18),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Horário',
                  prefixIcon: Icon(Icons.schedule_rounded),
                ),
                child: Text(
                  _formatTime(time),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (type == CalendarEntryType.fight) ...[
              const SizedBox(height: 15),
              const _EditorLabel(
                'O que fez essa situação começar?',
              ),
              const SizedBox(height: 7),
              TextField(
                controller: reason,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Conte de forma curta e sem julgamentos.',
                ),
              ),
              const SizedBox(height: 14),
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
              const SizedBox(height: 14),
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
              const SizedBox(height: 14),
              const _EditorLabel(
                'Como você percebeu o início?',
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
              const SizedBox(height: 14),
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
              const SizedBox(height: 14),
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
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(
                error!,
                style: const TextStyle(
                  color: TwinColors.burgundy,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 18),
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
                child: const Text(
                  'Salvar no calendário',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
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
        fontSize: 11.5,
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
      spacing: 7,
      runSpacing: 7,
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
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EntryDetails extends StatelessWidget {
  const _EntryDetails({required this.entry});

  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    final timeLabel =
        entry.time == null ? '' : ' · ' + _formatTime(entry.time!);

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
                        entry.type.label +
                            ' · ' +
                            _dayLabel(entry.date) +
                            timeLabel,
                        style: const TextStyle(
                          color: TwinColors.muted,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (entry.details.isNotEmpty) ...[
              const SizedBox(height: 18),
              for (final item in entry.details.entries) ...[
                _DetailRow(
                  label: item.key,
                  value: item.value,
                ),
                const SizedBox(height: 8),
              ],
            ],
          ],
        ),
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
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
