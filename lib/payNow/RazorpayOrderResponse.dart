class RazorpayOrderResponse {
  String? id;
  String? entity;
  int? amount;
  int? amountPaid;
  int? amountDue;
  String? currency;
  String? receipt;
  String? offerId;
  String? status;
  int? attempts;
  int? createdAt;

  RazorpayOrderResponse({
    this.id,
    this.entity,
    this.amount,
    this.amountPaid,
    this.amountDue,
    this.currency,
    this.receipt,
    this.offerId,
    this.status,
    this.attempts,
    this.createdAt,
  });

  factory RazorpayOrderResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderResponse(
      id: json["id"]?.toString(),
      entity: json["entity"]?.toString(),
      amount: json["amount"] as int?,
      amountPaid: json["amount_paid"] as int?,
      amountDue: json["amount_due"] as int?,
      currency: json["currency"]?.toString(),
      receipt: json["receipt"]?.toString(),
      offerId: json["offer_id"]?.toString(),
      status: json["status"]?.toString(),
      attempts: json["attempts"] as int?,
      createdAt: json["created_at"] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["entity"] = entity;
    data["amount"] = amount;
    data["amount_paid"] = amountPaid;
    data["amount_due"] = amountDue;
    data["currency"] = currency;
    data["receipt"] = receipt;
    data["offer_id"] = offerId;
    data["status"] = status;
    data["attempts"] = attempts;
    data["created_at"] = createdAt;
    return data;
  }
}
