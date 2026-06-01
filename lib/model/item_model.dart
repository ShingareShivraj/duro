class ItemModel {
  String? name;
  String? itemName;
  String? itemCode;
  String? image;
  double? actualQty;
  double? rate;
  double? igstAmount;
  double? cgstAmount;
  double? sgstAmount;

  ItemModel(
      {this.name,
      this.itemName,
      this.itemCode,
      this.image,
      this.actualQty,
      this.rate});

  ItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    itemName = json['item_name'];
    itemCode = json['item_code'];
    image = json['image'];
    actualQty = json['actual_qty'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['item_name'] = itemName;
    data['item_code'] = itemCode;
    data['image'] = image;
    data['actual_qty'] = actualQty;
    data['rate'] = rate;
    return data;
  }
}
