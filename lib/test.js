if (true) {
  console.log(c);
  function c() {}
  console.log(c);
}

if (function c() {}) {
  console.log(typeof c);
  console.log(c);
}
