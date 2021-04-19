const rangeInputBinding = new Shiny.InputBinding();

$.extend(rangeInputBinding, {

  find: function (scope) {
    return $(scope).find('.range-input');
  },

  initialize: function (el) {
    const range = el.querySelector('input');
    const rangeV = el.querySelector('.range-value');

    const newValue = Number( (range.value - range.min) * 100 / (range.max - range.min));
    const newPosition = 10 - (newValue * 0.2);
    rangeV.innerHTML = `<span>${range.value}</span>`;
    rangeV.style.left = `calc(${newValue}% + (${newPosition}px))`;

    function setValue() {
      const newValue = Number((range.value - range.min) * 100 / (range.max - range.min));
      const newPosition = 10 - (newValue * 0.2);
      rangeV.innerHTML = `<span>${range.value}</span>`;
      rangeV.style.left = `calc(${newValue}% + (${newPosition}px))`;
    }
    range.addEventListener('input', setValue);
  },

  getValue: function (el) {
    const input = el.querySelector('input');
    return parseFloat(input.value);
  },

  subscribe: function (el, callback) {
    const controls = el.querySelector('.range-input-controls');
    controls.addEventListener('click', function () {
      callback();
    });
    controls.addEventListener('change', function () {
      callback();
    });
    controls.addEventListener('input', function () {
      callback();
    });
  },
  
  setValue: function(el, msg) {
    const range = el.querySelector('input');
    var rangeV = el.querySelector('.range-value');
    range.value = msg['value'];

    var newValue = Number((msg['value'] - range.min) * 100 / (range.max - range.min));
    var newPosition = 10 - (newValue * 0.2);
    rangeV.innerHTML = `<span>${msg['value']}</span>`;
    rangeV.style.left = `calc(${newValue}% + (${newPosition}px))`;
  },
  
  receiveMessage: function(el, value) {
    this.setValue(el, value);
  }

});

Shiny.inputBindings.register(rangeInputBinding);