HTMLWidgets.widget({

  name: 'jstree',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    //var jt = new jstree(el.id)

    return {

      renderValue: function(x) {
              $elem = $('#' + el.id)
      
      $elem.jstree('destroy');
      

        console.log(x);

        var tree = $(el).jstree(x);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }
    };
  }
});