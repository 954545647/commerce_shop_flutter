function f() {
  console.log("I am outside!");
}

(function() {
  if (false) {
    // 重复声明一次函数f

    function f() {
      console.log("I am inside!");
    }
  }

  f();
})();

// 为什么输出结果是f is not a function,不是存在函数提升，让函数在预编译变成

function f() {
  console.log("I am outside!");
}

(function() {
  function f() {
    console.log("I am inside!");
  }

  if (false) {
    // 重复声明一次函数f

    function f() {
      console.log("I am inside!");
    }
  }

  f();
})();
