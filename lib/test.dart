main() {
  var list = [];
  var a = new Cart(1, "rx", 1, "1", "2");
  print(a);
  list.add(a);
  print(list);
}

class Cart {
  int id; // 商品id
  String goodName; // 商品名字
  int count; // 商品数量
  String price; // 商品单价
  String expressCost; // 商品运费

  Cart(int id, String goodName, int count, String price, String expressCost) {
    this.id = id;
    this.goodName = goodName;
    this.count = count;
    this.price = price;
    this.expressCost = expressCost;
  }
}
