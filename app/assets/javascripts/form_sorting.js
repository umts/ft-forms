$( document ).ready( function() {

  $('.sortable').sortable({});

  $('#add-new').click(function(){
    var newField = $('.row.padded-field').last().clone(true);
    setDefaultValues(newField);
    newField.appendTo('.container.sortable');
  });

  $('.remove').click(function(){
    fields = $('.row.padded-field');
    parentField = $(this).parents('.row.padded-field')
    if(fields.length > 1) {
      parentField.remove();
    }
    // If they want to remove the last field, just empty it instead.
    else setDefaultValues(parentField);
  });

});


function setDefaultValues(selector) {
  selector.find('textarea').text('');
  selector.find('.grabbable').text(newNumber());
  selector.find('select').val('');
}

function newNumber() {
  return $('.row.padded-field').length + 1;
}

//when new question is added:
//$( ".selector" ).sortable( "refresh" );
//reload all sortable items, cause new to be recognized
//
//send new order to server: http://api.jqueryui.com/sortable/#method-serialize
//$( ".sortable" ).sortable( "serialize", { key: "sort", expression: /(\d)[_](.+)/ } );
//
//span class?
//ui-icon ui-icon-arrowthick-2-n-s
