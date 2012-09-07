var Nicovlist = Backbone.Model.extend({
  defaults: {
    'name': ''
  },
  
  urlRoot: '/mylists',
  
  parse: function(response) {
    return response;
  }
});

var Nicovlists = Backbone.Collection.extend({
  model: Nicovlist,
  
  url: '/mylists'
});

var NicovlistView = Backbone.View.extend({
  initialize: function(options) {
    this.render();
  },
  
  render: function() {
    var nicovlists = new Nicovlists();
    nicovlists.fetch({
      success: function(nicovlists, response) {
        var $list = $('#nicovlists');
        $list.empty();
        for (var i = 0; i < nicovlists.length; i++) {
          var nicovlist = nicovlists.at(i);
          $list.html(_.template($('#nicovlist-template').html(), {
            mylist_id: nicovlist.get('mylist_id'),
            year:  nicovlist.get('year'),
            month: nicovlist.get('month'),
            day:   nicovlist.get('day'),
            name:  nicovlist.get('name')
          }));
        }
      },
      error: function(nicovlists, response) {
        alert(response);
      }
    });
  }
});


var nicovlist = new NicovlistView();
