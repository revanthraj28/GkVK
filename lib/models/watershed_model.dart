class WatershedDetails {
  final String district;
  final String taluk;
  final String hobli;
  final String subWatershedName;
  final String subWatershedCode;
  final String village;
  final String selectedCategory;

  WatershedDetails({
    required this.district,
    required this.taluk,
    required this.hobli,
    required this.subWatershedName,
    required this.subWatershedCode,
    required this.village,
    required this.selectedCategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'district': district,
      'taluk': taluk,
      'hobli': hobli,
      'subWatershedName': subWatershedName,
      'subWatershedCode': subWatershedCode,
      'village': village,
      'selectedCategory': selectedCategory,
    };
  }

  factory WatershedDetails.fromMap(Map<String, dynamic> map) {
    return WatershedDetails(
      district: map['district'],
      taluk: map['taluk'],
      hobli: map['hobli'],
      subWatershedName: map['subWatershedName'],
      subWatershedCode: map['subWatershedCode'],
      village: map['village'],
      selectedCategory: map['selectedCategory'],
    );
  }
}
