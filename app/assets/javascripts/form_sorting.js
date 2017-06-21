$( document ).ready( function() {

  $('.sortable').sortable({
    stop: function (event, ui) {
      reNumber();
    }
  });

  $('#add-new').click(function(){
    var newField = $('.row.padded-field').last().clone(true);
    appendField(newField, setDefaultValues)
  });

  $('.remove').click(function(){
    fields = $('.row.padded-field');
    parentField = $(this).parents('.row.padded-field')
    if(fields.length > 1) {
      parentField.remove();
    }
    // If they want to remove the last field, just empty it instead.
    else { 
      setDefaultValues(parentField);
    }
    reNumber();
  });

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

  $('#save').click(function(e){
    e.preventDefault;
    fields = $('.padded-field')
    var allFieldData = extractFieldData(fields)
    var formData = {
      name: $('#name input').val(),
      email: $('#email input').val(),
      reply_to: $('#reply-to input').val()
    }
    var data = {form: formData, fields: allFieldData}
    var ID = $('form').data('id')
    $.ajax({
      url: '/forms/' + ID,
      method: 'PUT',
      data: data
    }).done(function(){
      //TODO: something?
    });
  });

}); // END of document.ready

function checkValues(value){
  types = ['date', 'date/time', 'long-text', 'text', 'time']
  for (var i = 0; i < types.length; i++) {
    if(types[i] == value){
      return true;
    } 
  }
}
function extractFieldData(fields) {
  var allFieldData = {}
  $('.padded-field').each( function (index) {
    var fieldData = {};
    fieldData['number'] = index + 1;
    fieldData['prompt'] = $(this).find('textarea').val();
    fieldData['placeholder'] = $(this).find('.placeholder').val();
    fieldData['required'] = $(this).find('.required :checkbox').prop('checked');
    fieldData['data_type'] = $(this).find('.data-type select').val();
    allFieldData[index] = fieldData;
    //TODO: $(this).find('.options')
  }); 
  return allFieldData
}
function newNumber() {
  return $('.grabbable-number').length + 1;
}
function reNumber() {
  $('.grabbable-number').each(function (index){
    $(this).text(index + 1);
  })
}
function setDefaultValues(field) {
  field.find('textarea').val('');
  field.find('.grabbable-number').text(newNumber());
  field.find('select').val('');
}
function appendField(field, callback){
  callback(field);
  field.appendTo('.container.sortable');
}

