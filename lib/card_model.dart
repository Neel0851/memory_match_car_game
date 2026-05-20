class CarCardModel {
  final int id;
  final String carName;
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  CarCardModel({
    required this.id,
    required this.carName,
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CarCardModel copy() {
    return CarCardModel(
      id: id,
      carName: carName,
      imagePath: imagePath,
      isFlipped: isFlipped,
      isMatched: isMatched,
    );
  }
}