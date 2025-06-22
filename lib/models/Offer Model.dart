class OfferModel {
  final int id ;
  final int orderId;
  final String customerName;
  final int companyId;
  final String companyName;
  final double price;
  final int estimatedDeliveryTimeInDays;
  final String notes;
  final String status;
  final String createdAtUtc;
  final String? deliveryDateUtc;

  OfferModel({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.companyId,
    required this.companyName,
    required this.price,
    required this.estimatedDeliveryTimeInDays,
    required this.notes,
    required this.status,
    required this.createdAtUtc,
    required this.deliveryDateUtc,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      orderId: json['orderId'],
      customerName: json['customerName'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      price: (json['price'] as num).toDouble(),
      estimatedDeliveryTimeInDays: json['estimatedDeliveryTimeInDays'],
      notes: json['notes'],
      status: json['status'],
      createdAtUtc: json['createdAtUtc'],
      deliveryDateUtc: json['deliveryDateUtc'],
    );
  }
}