HTMLWidgets.widget({

  name: 'jstree',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    //var jt = new jstree(el.id)
    var tree;

    return {

      renderValue: function(x) {
        $(el).jstree('destroy');
        tree = $(el).jstree(x);
        
        $(el).on('open_node.jstree', function(e, data) { 
          Shiny.onInputChange(el.id + '_opened', data.node.name) 
        })
        
        $(el).on('changed.jstree', function(e, data) {
          var selected_nodes = $(el).jstree().get_selected(true)
          // TODO: Return list of objects instead of path -
          //        would require currently a special input handler
          //       https://github.com/rstudio/shiny/issues/1098
          var selected_paths = selected_nodes.map(function(o) { return($(el).jstree(true).get_path(o,'/'))})
          Shiny.onInputChange(el.id + '_selected', selected_paths)
        })
        
      },

      resize: function(width, height) {
        //$(el).jstree('destroy');
        //tree = $(el).jstree(x);
      }
    };
  }
});