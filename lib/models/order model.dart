class OrderModel {
  final int id;
  final String pickupLocation;
  final String destination;
  final double weightInKg;
  final String packageSize;
  final String ownerName;
  final String? companyName;
  final String status;
  final String details;
  final DateTime createdAtUtc;

  OrderModel({
    required this.id,
    required this.pickupLocation,
    required this.destination,
    required this.weightInKg,
    required this.packageSize,
    required this.ownerName,
    this.companyName,
    required this.status,
    required this.details,
    required this.createdAtUtc,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      pickupLocation: json['pickupLocation'],
      destination: json['destination'],
      weightInKg: (json['weightInKg'] as num).toDouble(),
      packageSize: json['packageSize'],
      ownerName: json['ownerName'],
      companyName: json['companyName'],
      status: json['status'],
      details: json['details'],
      createdAtUtc: DateTime.parse(json['createdAtUtc']),
    );
  }
}
