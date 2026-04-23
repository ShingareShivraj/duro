class SearchCustomerList {
  String? name;
  String? customerName;

  SearchCustomerList({this.name, this.customerName});

  SearchCustomerList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    customerName = json['customer_name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['name'] = name;
    data['customer_name'] = customerName;
    return data;
  }
}
