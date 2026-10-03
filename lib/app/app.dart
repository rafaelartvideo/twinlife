import 'package:flutter/material.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/app/widgets/twin_scaffold.dart';
import 'package:twinlife/features/calendar/calendar_page.dart';
import 'package:twinlife/features/home/home_page.dart';
import 'package:twinlife/features/memories/memories_page.dart';
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
  bool onboardingDone = false;
  int currentIndex = 0;

  static const pages = [
    HomePage(),
    MemoriesPage(),
    CalendarPage(),
    SummaryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!onboardingDone) {
      return OnboardingPage(
        onContinue: () => setState(() => onboardingDone = true),
      );
    }

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 26, offset: Offset(0, 8)),
            ],
          ),
          child: NavigationBar(
            height: 66,
            backgroundColor: Colors.transparent,
            indicatorColor: TwinColors.sand.withOpacity(.65),
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => setState(() => currentIndex = index),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Início'),
              NavigationDestination(icon: Icon(Icons.photo_library_outlined), selectedIcon: Icon(Icons.photo_library_rounded), label: 'Meiórias'),
              NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month_rounded), label: 'Calendário'),
              NavigationDestination(icon: Icon(Icons.favorite_border_rounded), selectedIcon: Icon(Icons.favorite_rounded), label: 'Nós'),
            ],
          ),
        ),
      ),
    );
  }
}
