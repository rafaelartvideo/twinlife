import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/features/onboarding/couple_setup.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.onComplete, super.key});

  final ValueChanged<CoupleSetup> onComplete;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final userName = TextEditingController();
  final partnerName = TextEditingController();
  final gratitude = TextEditingController();
  final improvement = TextEditingController();

  int step = 0;
  DateTime? userBirthday;
  DateTime? partnerBirthday;
  DateTime? relationshipDate;
  DateTime? lastIntimacyDate;

  String relationshipStatus = 'Namorados';
  String sexualOrientation = 'Prefiro não informar';
  final Set<String> goals = {'Valorizar o parceiro'};

  bool sexLifeActive = true;
  bool dataAllowed = true;
  bool galleryAllowed = true;
  bool locationAllowed = false;
  bool termsAccepted = false;
  String? error;

  static const totalSteps = 5;

  @override
  void dispose() {
    userName.dispose();
    partnerName.dispose();
    gratitude.dispose();
    improvement.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate(DateTime? current) {
    return showDatePicker(
      context: context,
      initialDate: current ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: 'Selecione a data',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
  }

  bool _validateStep() {
    setState(() => error = null);

    if (step == 1 &&
        (userName.text.trim().isEmpty || partnerName.text.trim().isEmpty)) {
      setState(() => error = 'Preencha os dois nomes.');
      return false;
    }

    if (step == 2 && relationshipDate == null) {
      setState(() => error = 'Informe a data especial de vocês.');
      return false;
    }

    if (step == 4 && !termsAccepted) {
      setState(() => error = 'Aceite os termos para continuar.');
      return false;
    }

    return true;
  }

  void _next() {
    if (!_validateStep()) return;

    if (step < totalSteps - 1) {
      setState(() => step += 1);
      return;
    }

    widget.onComplete(
      CoupleSetup(
        userName: userName.text.trim(),
        partnerName: partnerName.text.trim(),
        userBirthday: userBirthday,
        partnerBirthday: partnerBirthday,
        relationshipStatus: relationshipStatus,
        relationshipDate: relationshipDate,
        sexualOrientation: sexualOrientation,
        goals: goals,
        gratitude: gratitude.text.trim(),
        improvement: improvement.text.trim(),
        sexLifeActive: sexLifeActive,
        lastIntimacyDate: sexLifeActive ? lastIntimacyDate : null,
        dataAllowed: dataAllowed,
        galleryAllowed: galleryAllowed,
        locationAllowed: locationAllowed,
      ),
    );
  }

  void _back() {
    if (step == 0) return;
    setState(() {
      error = null;
      step -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwinColors.ivory,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              right: -18,
              top: 98,
              child: _SoftHeart(size: 92, opacity: .045),
            ),
            const Positioned(
              left: -22,
              bottom: 118,
              child: _SoftHeart(size: 78, opacity: .035),
            ),
            Column(
              children: [
                _QuizHeader(
                  step: step,
                  totalSteps: totalSteps,
                  onBack: step == 0 ? null : _back,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final slide = Tween<Offset>(
                        begin: const Offset(.055, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slide,
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey(step),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                      child: _stepContent(),
                    ),
                  ),
                ),
                _Footer(
                  step: step,
                  isLast: step == totalSteps - 1,
                  error: error,
                  onContinue: _next,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepContent() {
    switch (step) {
      case 0:
        return const _IntroStep();
      case 1:
        return _NamesStep(
          userName: userName,
          partnerName: partnerName,
          userBirthday: userBirthday,
          partnerBirthday: partnerBirthday,
          onUserBirthday: () async {
            final value = await _pickDate(userBirthday);
            if (value != null) setState(() => userBirthday = value);
          },
          onPartnerBirthday: () async {
            final value = await _pickDate(partnerBirthday);
            if (value != null) setState(() => partnerBirthday = value);
          },
        );
      case 2:
        return _RelationshipStep(
          status: relationshipStatus,
          orientation: sexualOrientation,
          date: relationshipDate,
          onStatus: (value) => setState(() => relationshipStatus = value),
          onOrientation: (value) => setState(() => sexualOrientation = value),
          onDate: () async {
            final value = await _pickDate(relationshipDate);
            if (value != null) setState(() => relationshipDate = value);
          },
        );
      case 3:
        return _GoalsStep(
          goals: goals,
          gratitude: gratitude,
          improvement: improvement,
          onGoal: (goal) {
            setState(() {
              goals.contains(goal) ? goals.remove(goal) : goals.add(goal);
            });
          },
        );
      default:
        return _PrivacyStep(
          sexLifeActive: sexLifeActive,
          lastIntimacyDate: lastIntimacyDate,
          dataAllowed: dataAllowed,
          galleryAllowed: galleryAllowed,
          locationAllowed: locationAllowed,
          termsAccepted: termsAccepted,
          onSexLifeChanged: (value) => setState(() => sexLifeActive = value),
          onLastIntimacy: () async {
            final value = await _pickDate(lastIntimacyDate);
            if (value != null) setState(() => lastIntimacyDate = value);
          },
          onDataChanged: (value) => setState(() => dataAllowed = value),
          onGalleryChanged: (value) => setState(() => galleryAllowed = value),
          onLocationChanged: (value) => setState(() => locationAllowed = value),
          onTermsChanged: (value) => setState(() => termsAccepted = value),
        );
    }
  }
}

class _QuizHeader extends StatelessWidget {
  const _QuizHeader({
    required this.step,
    required this.totalSteps,
    required this.onBack,
  });

  final int step;
  final int totalSteps;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / totalSteps;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 18, 6),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: onBack == null
                    ? const _BrandMark()
                    : IconButton(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
              ),
              const SizedBox(width: 7),
              Text(
                'TwinLife',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: TwinColors.burgundy,
                ),
              ),
              const Spacer(),
              Text(
                (step + 1).toString() + '/' + totalSteps.toString(),
                style: const TextStyle(
                  color: TwinColors.muted,
                  fontSize: TwinType.body,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 320),
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 5,
                backgroundColor: TwinColors.sand.withValues(alpha: .55),
                color: TwinColors.burgundy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE9D9CB),
                Color(0xFFC98676),
                TwinColors.burgundy,
              ],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x167A1E2D),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -24,
                top: -18,
                child: Icon(
                  Icons.favorite_rounded,
                  size: 178,
                  color: Colors.white.withValues(alpha: .075),
                ),
              ),
              const Positioned(
                left: 20,
                top: 20,
                child: Row(
                  children: [
                    _GlassHeart(),
                    SizedBox(width: 7),
                    _GlassHeart(small: true),
                  ],
                ),
              ),
              Positioned(
                left: 22,
                right: 22,
                bottom: 22,
                child: Text(
                  'Um espaço só de vocês.',
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 34,
                    height: .96,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _QuestionTitle(
          eyebrow: 'BEM-VINDOS',
          title: 'Prontos para montar a história de vocês?',
        ),
        const SizedBox(height: 12),
        const Text(
          '♡  datas  ·  conexão  ·  memórias  ·  cuidado',
          style: TextStyle(
            color: TwinColors.mocha,
            fontSize: TwinType.body,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NamesStep extends StatelessWidget {
  const _NamesStep({
    required this.userName,
    required this.partnerName,
    required this.userBirthday,
    required this.partnerBirthday,
    required this.onUserBirthday,
    required this.onPartnerBirthday,
  });

  final TextEditingController userName;
  final TextEditingController partnerName;
  final DateTime? userBirthday;
  final DateTime? partnerBirthday;
  final VoidCallback onUserBirthday;
  final VoidCallback onPartnerBirthday;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _QuestionTitle(
          eyebrow: 'VOCÊS DOIS',
          title: 'Qual o nome de vocês?',
        ),
        const SizedBox(height: 18),
        TextField(
          controller: userName,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Seu nome',
            hintText: 'Como podemos te chamar?',
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: partnerName,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nome do seu parceiro(a)',
            hintText: 'Como podemos chamá-lo(a)?',
          ),
        ),
        const SizedBox(height: 22),
        const _QuestionTitle(
          eyebrow: 'ANIVERSÁRIOS',
          title: 'Quando vocês nasceram?',
          compact: true,
        ),
        const SizedBox(height: 12),
        _DateField(
          label: 'Sua data de nascimento',
          value: userBirthday,
          onTap: onUserBirthday,
        ),
        const SizedBox(height: 10),
        _DateField(
          label: 'Data de nascimento do parceiro(a)',
          value: partnerBirthday,
          onTap: onPartnerBirthday,
        ),
      ],
    );
  }
}

class _RelationshipStep extends StatelessWidget {
  const _RelationshipStep({
    required this.status,
    required this.orientation,
    required this.date,
    required this.onStatus,
    required this.onOrientation,
    required this.onDate,
  });

  final String status;
  final String orientation;
  final DateTime? date;
  final ValueChanged<String> onStatus;
  final ValueChanged<String> onOrientation;
  final VoidCallback onDate;

  @override
  Widget build(BuildContext context) {
    const statuses = ['Namorados', 'Noivos', 'Casados', 'Enrolados'];
    const orientations = [
      'Heterossexual',
      'Homossexual',
      'Bissexual',
      'Pansexual',
      'Outra',
      'Prefiro não informar',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _QuestionTitle(
          eyebrow: 'NOSSA HISTÓRIA',
          title: 'Qual o status atual do relacionamento?',
        ),
        const SizedBox(height: 14),
        _ChoiceWrap(
          values: statuses,
          selected: status,
          onChanged: onStatus,
        ),
        const SizedBox(height: 22),
        const _QuestionTitle(
          eyebrow: 'DATA DE VOCÊS',
          title: 'Quando essa história começou?',
          compact: true,
        ),
        const SizedBox(height: 11),
        _DateField(
          label: 'Data do relacionamento',
          value: date,
          onTap: onDate,
          heart: true,
        ),
        const SizedBox(height: 22),
        const _QuestionTitle(
          eyebrow: 'SOBRE VOCÊS',
          title: 'Qual a orientação sexual do casal?',
          compact: true,
        ),
        const SizedBox(height: 11),
        _ChoiceWrap(
          values: orientations,
          selected: orientation,
          onChanged: onOrientation,
        ),
      ],
    );
  }
}

class _GoalsStep extends StatelessWidget {
  const _GoalsStep({
    required this.goals,
    required this.gratitude,
    required this.improvement,
    required this.onGoal,
  });

  final Set<String> goals;
  final TextEditingController gratitude;
  final TextEditingController improvement;
  final ValueChanged<String> onGoal;

  @override
  Widget build(BuildContext context) {
    const options = [
      'Melhorar a comunicação',
      'Amenizar as brigas',
      'Entender padrões',
      'Valorizar o parceiro',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _QuestionTitle(
          eyebrow: 'O QUE BUSCAM',
          title: 'O que esperam do TwinLife?',
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: options
              .map(
                (item) => _ChoicePill(
                  label: item,
                  selected: goals.contains(item),
                  onTap: () => onGoal(item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 22),
        const _QuestionTitle(
          eyebrow: 'CARINHO',
          title: 'Pelo que você é grato no seu parceiro?',
          compact: true,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: gratitude,
          minLines: 2,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Escreva o que vier à cabeça...',
          ),
        ),
        const SizedBox(height: 18),
        const _QuestionTitle(
          eyebrow: 'SINCERIDADE',
          title: 'O que gostaria que ele(a) melhorasse?',
          compact: true,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: improvement,
          minLines: 2,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Escreva com carinho...',
          ),
        ),
      ],
    );
  }
}

class _PrivacyStep extends StatelessWidget {
  const _PrivacyStep({
    required this.sexLifeActive,
    required this.lastIntimacyDate,
    required this.dataAllowed,
    required this.galleryAllowed,
    required this.locationAllowed,
    required this.termsAccepted,
    required this.onSexLifeChanged,
    required this.onLastIntimacy,
    required this.onDataChanged,
    required this.onGalleryChanged,
    required this.onLocationChanged,
    required this.onTermsChanged,
  });

  final bool sexLifeActive;
  final DateTime? lastIntimacyDate;
  final bool dataAllowed;
  final bool galleryAllowed;
  final bool locationAllowed;
  final bool termsAccepted;

  final ValueChanged<bool> onSexLifeChanged;
  final VoidCallback onLastIntimacy;
  final ValueChanged<bool> onDataChanged;
  final ValueChanged<bool> onGalleryChanged;
  final ValueChanged<bool> onLocationChanged;
  final ValueChanged<bool> onTermsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _QuestionTitle(
          eyebrow: 'INTIMIDADE',
          title: 'Vocês possuem vida sexual ativa?',
        ),
        const SizedBox(height: 12),
        _ToggleCard(
          title: sexLifeActive ? 'Sim' : 'Não',
          value: sexLifeActive,
          onChanged: onSexLifeChanged,
        ),
        if (sexLifeActive) ...[
          const SizedBox(height: 12),
          _DateField(
            label: 'Último momento íntimo',
            value: lastIntimacyDate,
            onTap: onLastIntimacy,
            heart: true,
          ),
        ],
        const SizedBox(height: 22),
        const _QuestionTitle(
          eyebrow: 'PERMISSÕES',
          title: 'O que o TwinLife pode acessar?',
          compact: true,
        ),
        const SizedBox(height: 10),
        _ToggleCard(
          title: 'Utilização dos dados do casal',
          value: dataAllowed,
          onChanged: onDataChanged,
        ),
        const SizedBox(height: 8),
        _ToggleCard(
          title: 'Galeria de fotos e vídeos',
          value: galleryAllowed,
          onChanged: onGalleryChanged,
        ),
        const SizedBox(height: 8),
        _ToggleCard(
          title: 'Localização',
          value: locationAllowed,
          onChanged: onLocationChanged,
        ),
        const SizedBox(height: 14),
        InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => onTermsChanged(!termsAccepted),
          child: Container(
            padding: const EdgeInsets.fromLTRB(11, 10, 13, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: TwinColors.sand),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: termsAccepted,
                  onChanged: (value) => onTermsChanged(value ?? false),
                  activeColor: TwinColors.burgundy,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    'Li e aceito os termos de uso.',
                    style: TextStyle(
                      color: TwinColors.ink,
                      fontSize: TwinType.body,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionTitle extends StatelessWidget {
  const _QuestionTitle({
    required this.eyebrow,
    required this.title,
    this.compact = false,
  });

  final String eyebrow;
  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: TwinColors.terracotta,
            fontSize: TwinType.caption,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            color: TwinColors.ink,
            fontSize: compact ? 25 : 30,
            height: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.heart = false,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final bool heart;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: TwinColors.sand.withValues(alpha: .85),
          ),
        ),
        child: Row(
          children: [
            if (heart) ...[
              const Icon(
                Icons.favorite_outline_rounded,
                size: 20,
                color: TwinColors.burgundy,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
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
                  const SizedBox(height: 5),
                  Text(
                    value == null ? 'DD / MM / AAAA' : _formatDate(value!),
                    style: TextStyle(
                      color:
                          value == null ? TwinColors.muted : TwinColors.ink,
                      fontSize: TwinType.input,
                      letterSpacing: value == null ? .4 : 0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: TwinColors.mocha,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: value
              ? TwinColors.sand
              : TwinColors.sand.withValues(alpha: .62),
        ),
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

class _ChoiceWrap extends StatelessWidget {
  const _ChoiceWrap({
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
            (value) => _ChoicePill(
              label: value,
              selected: value == selected,
              onTap: () => onChanged(value),
            ),
          )
          .toList(),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? TwinColors.burgundy : Colors.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: selected ? TwinColors.burgundy : TwinColors.sand,
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

class _Footer extends StatelessWidget {
  const _Footer({
    required this.step,
    required this.isLast,
    required this.error,
    required this.onContinue,
  });

  final int step;
  final bool isLast;
  final String? error;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 5, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            child: error == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: TwinColors.burgundy,
                        fontSize: TwinType.caption,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
          ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: onContinue,
              style: FilledButton.styleFrom(
                backgroundColor: TwinColors.burgundy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLast
                        ? 'Entrar no nosso espaço'
                        : step == 0
                            ? 'Começar'
                            : 'Continuar',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: TwinType.body,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftHeart extends StatelessWidget {
  const _SoftHeart({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Icon(
        Icons.favorite_rounded,
        size: size,
        color: TwinColors.burgundy.withValues(alpha: opacity),
      ),
    );
  }
}

class _GlassHeart extends StatelessWidget {
  const _GlassHeart({this.small = false});

  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 34.0 : 42.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .15),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: .35),
        ),
      ),
      child: Icon(
        Icons.favorite_rounded,
        color: Colors.white,
        size: small ? 15 : 19,
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

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return day + ' / ' + month + ' / ' + date.year.toString();
}
