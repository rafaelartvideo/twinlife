import 'package:flutter/material.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/app/widgets/twin_scaffold.dart';
import 'package:twinlife/features/calendar/calendar_page.dart';
import 'package:twinlife/features/home/home_page.dart';
import 'package:twinlife/features/memories/memories_page.dart';
import 'package:twinlife/features/onboarding/couple_setup.dart';
import 'package:twinlife/features/onboarding/onboarding_page.dart';
import 'package:twinlife/features/summary/summary_page.dart';

class TwinLifeApp extends StatelessWidget {
  const TwinLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TwinLife',
      debugShowCheckedModeBanner: false,
      theme: TwinTheme.light,
      home: const TwinWebFrame(child: TwinRoot()),
    );
  }
}

class TwinRoot extends StatefulWidget {
  const TwinRoot({super.key});

  @override
  State<TwinRoot> createState() => _TwinRootState();
}

class _TwinRootState extends State<TwinRoot> {
  CoupleSetup? setup;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (setup == null) {
      return OnboardingPage(
        onComplete: (value) {
          setState(() {
            setup = value;
            currentIndex = 2;
          });
        },
      );
    }

    final pages = [
      const HomePage(),
      const MemoriesPage(),
      CalendarPage(setup: setup!),
      const SummaryPage(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: currentIndex, children: pages),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 22,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: Colors.transparent,
            indicatorColor: TwinColors.sand.withValues(alpha: .65),
            selectedIndex: currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (index) {
              setState(() => currentIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Início',
              ),
              NavigationDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library_rounded),
                label: 'Memórias',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Calendário',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Nós',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
