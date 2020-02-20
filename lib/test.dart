main() {
  var list = [1, 2, 3, 4];
  list.forEach((item) {
    if (item == 2) {
      return;
    }
    print(item);
  });
}
