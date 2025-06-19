class CompanyModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String mainAddress;
  final String zipCode;
  final String taxNumber;
  final String responsibleManager;
  final String workTime;
  final String logo;
  final String tradeLicense;
  final List<String> photos;
  final String about;
  final String description;
  final String advantages;
  final String disadvantages;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhoneNumber;

  CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.mainAddress,
    required this.zipCode,
    required this.taxNumber,
    required this.responsibleManager,
    required this.workTime,
    required this.logo,
    required this.tradeLicense,
    required this.photos,
    required this.about,
    required this.description,
    required this.advantages,
    required this.disadvantages,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhoneNumber,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id']?.toString() ?? '', // ✅ تم تحويل الـ int إلى String هنا
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      mainAddress: json['mainAddress'] ?? '',
      zipCode: json['zipCode'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      responsibleManager: json['responsibleManger'] ?? '', // spelling ممكن تكون غلط في الـ API؟ تأكد
      workTime: json['workTime'] ?? '',
      logo: json['logo'] ?? '',
      tradeLicense: json['tradeLicense'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      about: json['about'] ?? '',
      description: json['description'] ?? '',
      advantages: json['advantages'] ?? '',
      disadvantages: json['disadvantages'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      ownerPhoneNumber: json['ownerPhoneNumber'] ?? '',
    );
  }
}
