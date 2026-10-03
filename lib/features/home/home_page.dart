import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/features/onboarding/couple_setup.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.setup, super.key});

  final CoupleSetup setup;

  @override
  Widget build(BuildContext context) {
    final age = _relationshipAge(setup.relationshipDate);
    final specialDate = setup.relationshipDate == null
        ? 'Data ainda não informada'
        : _formatShortDate(setup.relationshipDate!);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeHeader(
            userName: setup.userName,
            partnerName: setup.partnerName,
          ),
          const SizedBox(height: 16),
          _RelationshipHero(
            age: age,
            status: setup.relationshipStatus,
            specialDate: specialDate,
          ),
          const SizedBox(height: 18),
          const Text(
            'Hoje',
            style: TextStyle(
              color: TwinColors.ink,
              fontSize: TwinType.title,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          const _DailyCheckIn(),
          const SizedBox(height: 18),
          const Text(
            'Nosso espaço',
            style: TextStyle(
              color: TwinColors.ink,
              fontSize: TwinType.title,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          const _PrimaryActionCard(),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _SmallAction(
                  icon: Icons.favorite_border_rounded,
                  title: 'Conexão',
                  subtitle: 'Um momento só de vocês',
                  accent: TwinColors.intimacyPink,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _SmallAction(
                  icon: Icons.photo_library_outlined,
                  title: 'Memórias',
                  subtitle: 'Fotos, recados e músicas',
                  accent: TwinColors.specialBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _SmallAction(
                  icon: Icons.location_on_outlined,
                  title: 'Localização',
                  subtitle: 'Onde está meu amor?',
                  accent: TwinColors.terracotta,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _SmallAction(
                  icon: Icons.auto_awesome_outlined,
                  title: 'Assistente IA',
                  subtitle: 'Entender padrões juntos',
                  accent: TwinColors.softGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _GratitudeCard(
            gratitude: setup.gratitude,
            partnerName: setup.partnerName,
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.userName,
    required this.partnerName,
  });

  final String userName;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TWINLIFE',
                style: TextStyle(
                  color: TwinColors.terracotta,
                  fontSize: TwinType.caption,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userName + ' & ' + partnerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cormorantGaramond(
                  color: TwinColors.ink,
                  fontSize: 30,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: TwinColors.sand.withValues(alpha: .55),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_rounded,
            color: TwinColors.burgundy,
            size: 19,
          ),
        ),
      ],
    );
  }
}

class _RelationshipHero extends StatelessWidget {
  const _RelationshipHero({
    required this.age,
    required this.status,
    required this.specialDate,
  });

  final String age;
  final String status;
  final String specialDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE4CFC0),
            Color(0xFFC78072),
            TwinColors.burgundy,
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x147A1E2D),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -25,
            child: Icon(
              Icons.favorite_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: .07),
            ),
          ),
          Positioned(
            left: 20,
            top: 19,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .24),
                ),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: TwinType.caption,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        age,
                        style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontSize: 31,
                          height: .95,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        specialDate,
                        style: const TextStyle(
                          color: Color(0xFFF5E9E5),
                          fontSize: TwinType.body,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '♡',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 31,
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

class _DailyCheckIn extends StatelessWidget {
  const _DailyCheckIn();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TwinColors.sand.withValues(alpha: .75),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: TwinColors.sand.withValues(alpha: .35),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.mood_outlined,
              color: TwinColors.burgundy,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Como vocês estão hoje?',
                  style: TextStyle(
                    color: TwinColors.ink,
                    fontSize: TwinType.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Registrem o humor e uma palavra para o dia.',
                  style: TextStyle(
                    color: TwinColors.muted,
                    fontSize: TwinType.body,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            color: TwinColors.mocha,
            size: 19,
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionCard extends StatelessWidget {
  const _PrimaryActionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 13, 14),
      decoration: BoxDecoration(
        color: TwinColors.specialBlue.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TwinColors.specialBlue.withValues(alpha: .16),
        ),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 43,
            height: 43,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0x185078C9),
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                color: TwinColors.specialBlue,
              ),
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nosso calendário',
                  style: TextStyle(
                    color: TwinColors.ink,
                    fontSize: TwinType.title,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Datas especiais, intimidade, conflitos e ciclo.',
                  style: TextStyle(
                    color: TwinColors.muted,
                    fontSize: TwinType.body,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: TwinColors.specialBlue,
            size: 19,
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: TwinColors.sand.withValues(alpha: .7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .11),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: accent,
              size: 18,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: TwinColors.ink,
              fontSize: TwinType.body,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: TwinColors.muted,
              fontSize: TwinType.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class _GratitudeCard extends StatelessWidget {
  const _GratitudeCard({
    required this.gratitude,
    required this.partnerName,
  });

  final String gratitude;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final text = gratitude.trim().isEmpty
        ? 'Que tal escrever algo que você ama em ' + partnerName + '?'
        : gratitude.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TwinColors.sand.withValues(alpha: .32),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '♡',
            style: TextStyle(
              color: TwinColors.burgundy,
              fontSize: 23,
              height: 1,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Uma coisa boa para lembrar',
                  style: TextStyle(
                    color: TwinColors.ink,
                    fontSize: TwinType.body,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
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

String _relationshipAge(DateTime? start) {
  if (start == null) return 'A história de vocês';

  final now = DateTime.now();
  var years = now.year - start.year;
  var months = now.month - start.month;

  if (now.day < start.day) {
    months -= 1;
  }

  if (months < 0) {
    years -= 1;
    months += 12;
  }

  if (years > 0 && months > 0) {
    return years.toString() +
        (years == 1 ? ' ano e ' : ' anos e ') +
        months.toString() +
        (months == 1 ? ' mês' : ' meses');
  }

  if (years > 0) {
    return years.toString() + (years == 1 ? ' ano juntos' : ' anos juntos');
  }

  return months.toString() +
      (months == 1 ? ' mês juntos' : ' meses juntos');
}

String _formatShortDate(DateTime date) {
  return date.day.toString().padLeft(2, '0') +
      '/' +
      date.month.toString().padLeft(2, '0') +
      ' · nossa data';
}
