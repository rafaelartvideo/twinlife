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
      helpText: 'Escolha uma data',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
  }

  bool _validateStep() {
    setState(() => error = null);

    if (step == 1 &&
        (userName.text.trim().isEmpty || partnerName.text.trim().isEmpty)) {
      setState(() => error = 'Preencha os dois nomes para continuar.');
      return false;
    }
    if (step == 2 && relationshipDate == null) {
      setState(() => error = 'Escolha a data especial de vocês.');
      return false;
    }
    if (step == 4 && !termsAccepted) {
      setState(() => error = 'É preciso aceitar os termos para continuar.');
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
        child: Column(
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
                    begin: const Offset(.06, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: SingleChildScrollView(
                  key: ValueKey(step),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: _stepContent(),
                ),
              ),
            ),
            _Footer(
              isLast: step == totalSteps - 1,
              error: error,
              onContinue: _next,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepContent() {
    switch (step) {
      case 0:
        return _IntroStep(
          dataAllowed: dataAllowed,
          onDataChanged: (value) => setState(() => dataAllowed = value),
        );
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
          date: relationshipDate,
          onStatus: (value) => setState(() => relationshipStatus = value),
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
          galleryAllowed: galleryAllowed,
          locationAllowed: locationAllowed,
          termsAccepted: termsAccepted,
          onSexLifeChanged: (value) => setState(() => sexLifeActive = value),
          onLastIntimacy: () async {
            final value = await _pickDate(lastIntimacyDate);
            if (value != null) setState(() => lastIntimacyDate = value);
          },
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
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
  const _IntroStep({
    required this.dataAllowed,
    required this.onDataChanged,
  });

  final bool dataAllowed;
  final ValueChanged<bool> onDataChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 178,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE6D4C4),
                Color(0xFFC58A79),
                TwinColors.burgundy,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -22,
                child: Icon(
                  Icons.favorite_rounded,
                  size: 150,
                  color: Colors.white.withValues(alpha: .08),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Entender mais.\nCuidar melhor.',
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 31,
                    height: .95,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const _StepTitle(
          eyebrow: 'BEM-VINDOS',
          title: 'Vamos conhecer um pouco de vocês?',
          subtitle:
              'Esse quiz configura datas, calendário e experiências do casal. Depois vocês podem alterar tudo.',
        ),
        const SizedBox(height: 16),
        _ToggleCard(
          icon: Icons.auto_awesome_outlined,
          title: 'Personalizar a experiência',
          subtitle: 'Usar as respostas para adaptar o TwinLife ao casal.',
          value: dataAllowed,
          onChanged: onDataChanged,
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
        const _StepTitle(
          eyebrow: 'VOCÊS DOIS',
          title: 'Primeiro, quem faz parte dessa história?',
          subtitle:
              'Usaremos os nomes e aniversários nas experiências e datas importantes.',
        ),
        const SizedBox(height: 18),
        _InputCard(
          label: 'Seu nome',
          child: TextField(
            controller: userName,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Como podemos te chamar?',
            ),
          ),
        ),
        const SizedBox(height: 10),
        _DateCard(
          label: 'Seu aniversário',
          value: userBirthday,
          onTap: onUserBirthday,
        ),
        const SizedBox(height: 12),
        _InputCard(
          label: 'Nome do seu amor',
          child: TextField(
            controller: partnerName,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Nome do seu parceiro(a)',
            ),
          ),
        ),
        const SizedBox(height: 10),
        _DateCard(
          label: 'Aniversário dele(a)',
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
    required this.date,
    required this.onStatus,
    required this.onDate,
  });

  final String status;
  final DateTime? date;
  final ValueChanged<String> onStatus;
  final VoidCallback onDate;

  @override
  Widget build(BuildContext context) {
    const statuses = ['Namorados', 'Noivos', 'Casados', 'Enrolados'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepTitle(
          eyebrow: 'NOSSA HISTÓRIA',
          title: 'Como vocês definem o relacionamento?',
          subtitle: 'A data especial entra automaticamente no calendário.',
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: statuses
              .map(
                (item) => _ChoicePill(
                  label: item,
                  selected: item == status,
                  onTap: () => onStatus(item),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        _DateCard(
          label: 'Quando essa história começou?',
          value: date,
          onTap: onDate,
          icon: Icons.favorite_outline_rounded,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: TwinColors.sand.withValues(alpha: .30),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: TwinColors.burgundy,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Aniversários e a data do relacionamento aparecerão em “Datas especiais”.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: TwinColors.mocha,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
        const _StepTitle(
          eyebrow: 'O QUE BUSCAM',
          title: 'O que vocês querem construir por aqui?',
          subtitle: 'Pode escolher mais de uma opção.',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
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
        const SizedBox(height: 18),
        _InputCard(
          label: 'Pelo que você é grato no seu parceiro?',
          child: TextField(
            controller: gratitude,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Uma qualidade, gesto ou lembrança...',
            ),
          ),
        ),
        const SizedBox(height: 10),
        _InputCard(
          label: 'O que gostaria que ele(a) melhorasse?',
          child: TextField(
            controller: improvement,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Escreva com carinho e sinceridade.',
            ),
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
    required this.galleryAllowed,
    required this.locationAllowed,
    required this.termsAccepted,
    required this.onSexLifeChanged,
    required this.onLastIntimacy,
    required this.onGalleryChanged,
    required this.onLocationChanged,
    required this.onTermsChanged,
  });

  final bool sexLifeActive;
  final DateTime? lastIntimacyDate;
  final bool galleryAllowed;
  final bool locationAllowed;
  final bool termsAccepted;
  final ValueChanged<bool> onSexLifeChanged;
  final VoidCallback onLastIntimacy;
  final ValueChanged<bool> onGalleryChanged;
  final ValueChanged<bool> onLocationChanged;
  final ValueChanged<bool> onTermsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepTitle(
          eyebrow: 'PRIVACIDADE',
          title: 'Últimos detalhes antes de começar',
          subtitle: 'Vocês controlam o que o app usa e compartilha.',
        ),
        const SizedBox(height: 15),
        _ToggleCard(
          icon: Icons.favorite_border_rounded,
          title: 'Vida sexual ativa',
          subtitle: 'Ajuda a organizar o calendário íntimo do casal.',
          value: sexLifeActive,
          onChanged: onSexLifeChanged,
        ),
        if (sexLifeActive) ...[
          const SizedBox(height: 9),
          _DateCard(
            label: 'Último momento íntimo',
            value: lastIntimacyDate,
            onTap: onLastIntimacy,
            icon: Icons.favorite_rounded,
          ),
        ],
        const SizedBox(height: 9),
        _ToggleCard(
          icon: Icons.photo_library_outlined,
          title: 'Acesso à galeria',
          subtitle: 'Para fotos, vídeos, álbuns e dedicatórias.',
          value: galleryAllowed,
          onChanged: onGalleryChanged,
        ),
        const SizedBox(height: 9),
        _ToggleCard(
          icon: Icons.location_on_outlined,
          title: 'Localização',
          subtitle: 'Pode ser ativada agora ou configurada depois.',
          value: locationAllowed,
          onChanged: onLocationChanged,
        ),
        const SizedBox(height: 13),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => onTermsChanged(!termsAccepted),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: TwinColors.sand),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: termsAccepted,
                  onChanged: (value) => onTermsChanged(value ?? false),
                  activeColor: TwinColors.burgundy,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Li e aceito os termos de uso e entendo como meus dados, galeria e localização serão utilizados.',
                    style: TextStyle(
                      color: TwinColors.ink,
                      fontSize: 11.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
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

class _StepTitle extends StatelessWidget {
  const _StepTitle({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: TwinColors.terracotta,
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: GoogleFonts.cormorantGaramond(
            color: TwinColors.ink,
            fontSize: 31,
            height: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: TwinColors.muted,
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
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
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.label,
    required this.value,
    required this.onTap,
    this.icon = Icons.cake_outlined,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: TwinColors.sand.withValues(alpha: .8),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: TwinColors.burgundy),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value == null ? label : label + ' · ' + _formatDate(value!),
                style: TextStyle(
                  color: value == null ? TwinColors.muted : TwinColors.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
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
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.fromLTRB(13, 11, 9, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value
              ? TwinColors.sand
              : TwinColors.sand.withValues(alpha: .6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: TwinColors.sand.withValues(alpha: value ? .55 : .25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: TwinColors.burgundy, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: TwinColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: TwinColors.muted,
                    fontSize: 10.2,
                    height: 1.3,
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
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.isLast,
    required this.error,
    required this.onContinue,
  });

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
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
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
                    isLast ? 'Entrar no nosso espaço' : 'Continuar',
                    style: const TextStyle(fontWeight: FontWeight.w800),
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
  return day + '/' + month + '/' + date.year.toString();
}
