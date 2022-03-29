class FoodModal {
  String foodName;
  int? count;
  String? weight;
  String? calories;
  String? proteins;
  String? carbohydrates;
  String? fibre;
  String? timeStamp;

  FoodModal(
      {required this.foodName,
      this.count,
      this.weight,
      this.calories,
      this.proteins,
      this.carbohydrates,
      this.fibre,
      this.timeStamp});
}
