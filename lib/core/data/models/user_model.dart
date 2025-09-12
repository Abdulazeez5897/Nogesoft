class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String professionalHeadline;
  final String location;
  final List<String> skills;
  final List<Experience> experience;
  final List<Education> education;
  final String? resumeUrl;
  final String? resumeUploadDate;
  final String? profileImageUrl;
  final String? phoneNumber;
  final String? portfolioUrl;
  final List<String> languages;
  final List<String> certifications;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.professionalHeadline,
    required this.location,
    required this.skills,
    required this.experience,
    required this.education,
    this.resumeUrl,
    this.resumeUploadDate,
    this.profileImageUrl,
    this.phoneNumber,
    this.portfolioUrl,
    this.languages = const [],
    this.certifications = const [],
  });
}

class Experience {
  final String position;
  final String company;
  final String duration;
  final String? description;

  Experience({
    required this.position,
    required this.company,
    required this.duration,
    this.description,
  });
}

class Education {
  final String degree;
  final String institution;
  final String year;
  final String? fieldOfStudy;
  final String? grade;

  Education({
    required this.degree,
    required this.institution,
    required this.year,
    this.fieldOfStudy,
    this.grade,
  });
}