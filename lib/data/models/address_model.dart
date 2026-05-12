class AddressModel {
  AddressModel({
    required this.id,
    required this.city,
    required this.ward,
    required this.street,
    required this.number,
    this.isDefault = false,
  });

  final String id;
  final String city;
  final String ward;
  final String street;
  final String number;
  final bool isDefault;
}
