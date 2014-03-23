(function () {
  "use strict";

  var i = 0;
  for (; i < 3; i += 1) {
    setTimeout((function (idx) {
      return function addSmoke () {
        var
          time = 7500,
          smoke = $('<div />', {
            class: 'smoke smoke' + (idx + 1),
            css: {
              opacity: 0
            }
          });
        
        // add to viewport
        $(smoke).appendTo('.smoke-box');

        // animate
        $.when(
          // animate to 100% opacity in half the time (fade in)
          $(smoke).animate({
            opacity: 1
          }, {
            duration: time * 0.2,
            easing: 'linear',
            queue: false,
            
            // animate to 0% opacity in the remaining time (fade out)
            complete: function () {
              $(smoke).animate({
                opacity: 0
              }, {
                duration: time * 0.8,
                easing: 'linear',
                queue: false
              });
            }
          }),

          // animate movement
          $(smoke).animate({
            //bottom: $('.smoke-box').height()
            bottom: '450px'
          }, {
            duration: time,
            easing: 'linear',
            queue: false
          })

        // when all down, remove and add new random smoke
        ).then(function () {
          $(smoke).remove();
          addSmoke();
        });
      };
    }(i % 3)), i * 2500);
  }
}());