var obj = {
  id: 1,
  supplierName: "rex221",
  phone: "13250504940",
  address: "广东省广州市天河区",
  createdAt: "2020-02-19T06:45:45.000Z",
  updatedAt: "2020-02-19T06:45:45.000Z"
};

obj = JSON.parse(JSON.stringify(obj).replace(/id/g, "goodId"));
console.log(obj);
