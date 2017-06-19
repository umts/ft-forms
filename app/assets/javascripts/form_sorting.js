$( document ).ready( function() {

  $('.sortable').sortable();

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

  $('#save').click(function(e){
    e.preventDefault;
    var formID = 4; //something
    var fieldsCount = $('.row.padded-field').length;
    var fieldData = []
    $.ajax({
      url: '/forms/4/update',
      data: []
    }).done(function(){
      //something?
    })
  })

  $('.data-type').change(function(){
    placeholder = $(this).parents('.padded-field').find('.placeholder');
    value = $(this).children('select').val()
    if(checkValues(value) == true) {
      if(placeholder.children().length == 0) {
        $('<input type="text" value="">').appendTo(placeholder);
      }
    } else {
      placeholder.children().remove();
    }
  });

});

function checkValues(value){
  types = ['date', 'date/time', 'long-text', 'text', 'time']
  for (var i = 0; i < types.length; i++) {
    if(types[i] == value){
      return true;
    } 
  }
}

function extractFieldData(fields) {
  fields.each(function(){
    var fieldData = {}
    fieldData['text'] = $(this).find('textarea').text();
    fieldData['data_type'] = $(this).find('select').val();
    fieldData['required'] = $(this).find('.required :checkbox').prop('checked');
  })
}

function setDefaultValues(selector) {
  selector.find('textarea').text('');
  selector.find('.grabbable').text(newNumber());
  selector.find('select').val('');
}

function newNumber() {
  return $('.row.padded-field').length + 1;
}

//when Preview: 
//$( ".selector" ).sortable( "refresh" );
//reload all sortable items, cause new to be recognized
//
//send new order to server: http://api.jqueryui.com/sortable/#method-serialize
//$( ".sortable" ).sortable( "serialize", { key: "sort", expression: /(\d)[_](.+)/ } );
//
