import 'package:flutter/material.dart';
import 'package:twinlife/app/theme/twin_theme.dart';

class TwinWebFrame extends StatelessWidget {
  const TwinWebFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktopPreview = constraints.maxWidth >= 700;

        if (!isDesktopPreview) {
          return ColoredBox(
            color: TwinColors.ivory,
            child: SizedBox.expand(child: child),
          );
        }

        final availableHeight = constraints.maxHeight - 36;
        final phoneHeight = availableHeight > 844 ? 844.0 : availableHeight;

        return ColoredBox(
          color: const Color(0xFFF2EBE3),
          child: Center(
            child: Container(
              width: 414,
              height: phoneHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF171717),
                borderRadius: BorderRadius.circular(48),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 42,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(39),
                child: ColoredBox(
                  color: TwinColors.ivory,
                  child: Stack(
                    children: [
                      Positioned.fill(child: child),
                      const Positioned(
                        top: 9,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Center(
                            child: _DynamicIsland(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 27,
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class TwinPageHeader extends StatelessWidget {
  const TwinPageHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class TwinSectionTitle extends StatelessWidget {
  const TwinSectionTitle(this.title, {this.action, super.key});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(
              color: TwinColors.burgundy,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
