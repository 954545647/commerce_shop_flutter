async function test() {
  let c = await test2();
  console.log(c);
}

function test2() {
  return new Promise((resolve, reject) => {
    resolve(1);
  });
}

(async function() {
  await test();
  console.log(2);
})();
