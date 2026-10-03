class CoupleSetup {
  const CoupleSetup({
    required this.userName,
    required this.partnerName,
    required this.userBirthday,
    required this.partnerBirthday,
    required this.relationshipStatus,
    required this.relationshipDate,
    required this.goals,
    required this.gratitude,
    required this.improvement,
    required this.sexLifeActive,
    required this.lastIntimacyDate,
    required this.dataAllowed,
    required this.galleryAllowed,
    required this.locationAllowed,
  });

  final String userName;
  final String partnerName;
  final DateTime? userBirthday;
  final DateTime? partnerBirthday;
  final String relationshipStatus;
  final DateTime? relationshipDate;
  final Set<String> goals;
  final String gratitude;
  final String improvement;
  final bool sexLifeActive;
  final DateTime? lastIntimacyDate;
  final bool dataAllowed;
  final bool galleryAllowed;
  final bool locationAllowed;
}
