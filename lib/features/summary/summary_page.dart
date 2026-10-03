import 'package:flutter/material.dart';
import 'package:twinlife/app/theme/twin_theme.dart';
import 'package:twinlife/app/widgets/twin_scaffold.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TwinPageHeader(
            title: 'Nosso resumo',
            subtitle: 'Uma leitura leve da conexÃ£o de vocÃªs nos Ãºltimos dias.',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: TwinColors.burgundy,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('NÃ­vel de conexÃ£o', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('84', style: TextStyle(color: Colors.white, fontSize: 48, height: 1, fontWeight: FontWeight.w800)),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6, left: 4),
                      child: Text('/100', style: TextStyle(color: Colors.white60, fontSize: 13)),
                    ),
                    Spacer(),
                    Icon(Icons.favorite_rounded, color: Color(0xFFE7B8B9), size: 32),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: .84,
                    minHeight: 8,
                    backgroundColor: Color(0xFF954555),
                    valueColor: AlwaysStoppedAnimation(Color(0xFFD4B483)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('+12% de conexÃ£o neste mÃªs', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: _Stat('184', 'momentos juntos')),
              SizedBox(width: 10),
              Expanded(child: _Stat('52', 'elogios trocados')),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(child: _Stat('12', 'dias seguidos')),
              SizedBox(width: 10),
              Expanded(child: _Stat('4', 'novas memÃ³rias')),
            ],
          ),
          const SizedBox(height: 28),
          const TwinSectionTitle('Insights de vocÃªs', action: 'Ver todos'),
          const SizedBox(height: 14),
         ÛÛœİÒ[œÚYÚ
XÛÛœË™˜]›Üš]WÛİ][™WÜ›İ[™Y	Õ›ØğêœÈ\İ0èÛÈXZ\È™\Ù[\ÉË	Õ]™\˜[HXZ\È[ÛY[ÜÈH]X[YYH[ÜÈ™\İHÙ[X[˜K‰ÊKˆÛÛœİÚ^™Y›Ş
ZYÚˆL
KˆÛÛœİÒ[œÚYÚ
XÛÛœË˜Ú]ØX˜›WÛİ][™WÜ›İ[™Y	ÓXZ\È[]œ˜\È]YH\›Ş[X[IË	ÓÜÈ[ÙÚ[ÜÈ][Y[\˜[HH\ÜÛÈ›Ü[XÙHHÛÛ™^0èÛÈH›ØğêœË‰ÊKˆÛÛœİÚ^™Y›Ş
ZYÚˆL
KˆÛÛœİÒ[œÚYÚ
XÛÛœË˜˜[[˜ÙWÜ›İ[™Y	Ñ\]Z[0ëXœš[È[H]›ÛpéğèÛÉË	ĞH›İ[˜HHÜÈ[ÛY[ÜÈHÚ\ÈšXØ\˜[HXZ\È\]Z[Xœ˜YÜË‰ÊKˆÛÛœİÚ^™Y›Ş
ZYÚˆŒŠKˆÛÛZ[™\ŠˆY[™ÎˆÛÛœİYÙR[œÙ]Ë˜[
N
KˆXÛÜ˜][Ûˆ›ŞXÛÜ˜][ÛŠˆÛÛÜˆÚ[ÛÛÜœËœØ[™Ú]ÜXÚ]J
Kˆ›Ü™\”˜Y]\Îˆ›Ü™\”˜Y]\Ë˜Ú\˜İ[\ŠŒŠKˆ
KˆÚ[ˆÛÛœİ›İÊˆÚ[™[ˆÂˆXÛÛŠXÛÛœË›YÚ[—Ûİ][™WÜ›İ[™YÛÛÜˆÚ[ÛÛÜœË\œ˜XÛİJKˆÚ^™Y›Ş
ÚYˆLŠKˆ^[™Y
ˆÚ[ˆ^
ˆ	Ô]YH[™\Ù\˜\™[H[H[\È\İHÙ[X[˜H\˜H˜^™\ˆ[ÛÈ›İ›È[ÜÏÉËˆİ[Nˆ^İ[JÛÛÜˆÚ[ÛÛÜœËš[šËZYÚˆKK›ÛÙZYÚˆ›ÛÙZYÚÍŒ
Kˆ
Kˆ
KˆKˆ
Kˆ
KˆKˆ
Kˆ
NÂˆBŸB‚˜Û\ÜÈÔİ]^[™Èİ][\ÜÕÚYÙ]ÂˆÛÛœİÔİ]
\Ë˜[YK\Ë›X™[
NÂ‚ˆš[˜[İš[™È˜[YNÂˆš[˜[İš[™ÈX™[Â‚ˆİ™\œšYBˆÚYÙ]Z[
Z[ÛÛ^ÛÛ^
HÂˆ™]\›ˆÛÛZ[™\ŠˆY[™ÎˆÛÛœİYÙR[œÙ]Ë˜[
MÊKˆXÛÜ˜][Ûˆ›ŞXÛÜ˜][ÛŠˆÛÛÜˆÛÛÜœËÚ]Kˆ›Ü™\”˜Y]\Îˆ›Ü™\”˜Y]\Ë˜Ú\˜İ[\ŠŒJKˆ›Ü™\ˆ›Ü™\‹˜[
ÛÛÜˆÚ[ÛÛÜœËœØ[™Ú]ÜXÚ]JMJJKˆ
KˆÚ[ˆÛÛ[[ŠˆÜ›ÜÜĞ^\Ğ[YÛ›Y[ˆÜ›ÜÜĞ^\Ğ[YÛ›Y[œİ\ˆÚ[™[ˆÂˆ^
˜[YKİ[NˆÛÛœİ^İ[JÛÛÜˆÚ[ÛÛÜœË˜\™İ[™K›ÛÚ^™NˆŒË›ÛÙZYÚˆ›ÛÙZYÚÎ
JKˆÛÛœİÚ^™Y›Ş
ZYÚˆÊKˆ^
X™[İ[NˆÛÛœİ^İ[JÛÛÜˆÚ[ÛÛÜœË›]]Y›ÛÚ^™NˆLJJKˆKˆ
Kˆ
NÂˆBŸB‚˜Û\ÜÈÒ[œÚYÚ^[™Èİ][\ÜÕÚYÙ]ÂˆÛÛœİÒ[œÚYÚ
\ËšXÛÛ‹\Ë]K\ËœİX]JNÂ‚ˆš[˜[XÛÛ‘]HXÛÛÂˆš[˜[İš[™È]NÂˆš[˜[İš[™ÈİX]NÂ‚ˆİ™\œšYBˆÚYÙ]Z[
Z[ÛÛ^ÛÛ^
HÂˆ™]\›ˆÛÛZ[™\ŠˆY[™ÎˆÛÛœİYÙR[œÙ]Ë˜[
MŠKˆXÛÜ˜][Ûˆ›ŞXÛÜ˜][ÛŠˆÛÛÜˆÛÛÜœËÚ]Kˆ›Ü™\”˜Y]\Îˆ›Ü™\”˜Y]\Ë˜Ú\˜İ[\ŠŒJKˆ›Ü™\ˆ›Ü™\‹˜[
ÛÛÜˆÚ[ÛÛÜœËœØ[™Ú]ÜXÚ]JJJKˆ
KˆÚ[ˆ›İÊˆÚ[™[ˆÂˆÚ\˜ÛP]˜]\Š˜XÚÙÜ›İ[™ÛÛÜˆÚ[ÛÛÜœËš]›ÜKÚ[ˆXÛÛŠXÛÛ‹ÛÛÜˆÚ[ÛÛÜœË˜\™İ[™JJKˆÛÛœİÚ^™Y›Ş
ÚYˆLÊKˆ^[™Y
ˆÚ[ˆÛÛ[[ŠˆÜ›ÜÜĞ^\Ğ[YÛ›Y[ˆÜ›ÜÜĞ^\Ğ[YÛ›Y[œİ\ˆÚ[™[ˆÂˆ^
]Kİ[NˆÛÛœİ^İ[J›ÛÙZYÚˆ›ÛÙZYÚÍÌ›ÛÚ^™NˆL‹JJKˆÛÛœİÚ^™Y›Ş
ZYÚˆÊKˆ^
İX]Kİ[NˆÛÛœİ^İ[JÛÛÜˆÚ[ÛÛÜœË›]]Y›ÛÚ^™NˆLKZYÚˆKŒÍJJKˆKˆ
Kˆ
KˆÛÛœİXÛÛŠXÛÛœË˜Ú]œ›Û—ÜšYÚÜ›İ[™YÛÛÜˆÚ[ÛÛÜœË›[ØÚJKˆKˆ
Kˆ
NÂˆBŸB