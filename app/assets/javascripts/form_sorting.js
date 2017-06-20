$( document ).ready( function() {

  $('.sortable').sortable();
  //TODO: trigger a re-number function when finished sorting

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
    else setDefaultValues(parentField);
  });

  $('#save').click(function(e){
    e.preventDefault;
    var allFieldData = {}
    $('.padded-field').each( function (index) {
      var fieldData = {};
      fieldData['number'] = index + 1;
      fieldData['prompt'] = $(this).find('textarea').val();
      fieldData['placeholder'] = $(this).find('.placeholder').val();
      fieldData['required'] = $(this).find('.required :checkbox').prop('checked');
      fieldData['dataType'] = $(this).find('.data-type').val();
      allFieldData[index] = fieldData;
      //TODO: $(this).find('.options')
    });
    var formData = {
      name: $('#name').val(),
      email: $('#email').val(),
      replyTo: $('#reply-to').val()
    }
    var data = {form: formData, fields: allFieldData}
    var ID = $('#id').val();
    $.ajax({
      url: '/forms/' + ID,
      method: 'PUT',
      data: data
    }).done(function(){
      //TODO: something?
    });
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

function newNumber() {
  return $('.row.padded-field').length + 1;
}

function setDefaultValues(field) {
  field.find('textarea').val('');
  field.find('.grabbable').text(newNumber());
  field.find('select').val('');
}

function appendField(field, callback){
  callback(field);
  field.appendTo('.container.sortable');
}

