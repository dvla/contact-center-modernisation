(function(document, window, undefined){
	// Production steps of ECMA-262, Edition 5, 15.4.4.17
	// Reference: http://es5.github.io/#x15.4.4.17
	if (!Array.prototype.some) {
	  Array.prototype.some = function(fun/*, thisArg*/) {
	    'use strict';

	    if (this == null) {
	      throw new TypeError('Array.prototype.some called on null or undefined');
	    }

	    if (typeof fun !== 'function') {
	      throw new TypeError();
	    }

	    var t = Object(this);
	    var len = t.length >>> 0;

	    var thisArg = arguments.length >= 2 ? arguments[1] : void 0;
	    for (var i = 0; i < len; i++) {
	      if (i in t && fun.call(thisArg, t[i], i, t)) {
	        return true;
	      }
	    }

	    return false;
	  };
	}
})(document, window);

function nextBtnClick(event) {
	event = event || window.event;

	function validateAnswer(){
		var hasValue;
		var allFieldsets = document.getElementsByTagName('fieldset');
		var allTextareas = allFieldsets.length || document.getElementsByTagName('textarea');
		if(allFieldsets.length){
			hasValue = Array.prototype.some.apply(allFieldsets[0].getElementsByTagName('input'), [function(el){ return el.checked;}]);
		} else if(allTextareas.length){
			var txt = allTextareas[0];
			hasValue = !txt.value || !txt.value.length || !txt.value.trim().length || txt.value.trim().length > 3;
		}

		if(!hasValue) document.getElementById('noAnswerError').style.display = 'block';
		return hasValue;
	}

	if(validateAnswer()) goToNextQuestion();

	if(event.preventDefault) event.preventDefault();
	event.returnValue = false;
	event.cancelBubble = true;
	return false;
}