class ReelItem {
  final int itemId;
  final int displayOrder;
  final int price;

  const ReelItem({
    required this.itemId,
    required this.displayOrder,
    required this.price,
  });

  factory ReelItem.fromJson(Map<String, dynamic> json) {
    return ReelItem(
      itemId: json['itemId'],
      displayOrder: json['displayOrder'],
      price: json['price'],
    );
  }
}
