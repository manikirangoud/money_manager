class MoneyExpenseModal {
  int? id;
  double? amountSpent;
  String? spentName;
  String? timeStamp;
  String? categories;
  String? subCategories;
  String? type;
  String? locationName;

  MoneyExpenseModal(
      {this.id,
      this.amountSpent,
      this.spentName,
      this.timeStamp,
      this.categories,
      this.subCategories,
      this.type,
      this.locationName});
}

class Location {
  String? latitude;
  String? longitude;
  String? name;
}
