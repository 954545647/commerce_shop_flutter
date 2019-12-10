class GoodsCardModel {
  // 封面地址
  final String coverUrl;
  // 商品名
  final String userName;
  // 商品描述
  final String description;
  // 商品分类
  final String type;
  // 商品价格
  final String price;
  // 库存
  final String stock;
  // 生长周期
  final String growth;

  const GoodsCardModel({
    this.coverUrl,
    this.userName,
    this.description,
    this.type,
    this.price,
    this.stock,
    this.growth,
  });

  factory GoodsCardModel.fromJson(dynamic json) {
    return GoodsCardModel(
      coverUrl: json['coverUrl'],
      userName: json['userName'],
      description: json['description'],
      type: json['type'],
      price: json['price'],
      stock: json['stock'],
      growth: json['growth'],
    );
  }
}
