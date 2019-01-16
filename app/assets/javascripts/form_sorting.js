$( document ).ready( function() {
  $('.sortable').sortable({
    stop: function() {
      reNumber();
    },
  });

  $('#add-new').click(function() {
    const newField = $('.row.padded-field.hidden').clone(true).removeClass('hidden');
    newField.find('.grabbable-number input').attr('name', newName('number'));
    newField.find('.grabbable-number input').attr('id', newID('number'));
    newField.find('.grabbable-number input').val(newNumber());
    newField.appendTo('.container.sortable');
  });

  $('.remove').click(function() {
    const fields = $('.row.padded-field');
    const parentField = $(this).parents('.row.padded-field');
    if (fields.length > 1) {
      parentField.remove();
    } else { // If they want to remove the last field, just empty it instead.
      setDefaultValues(parentField);
    }
    reNumber();
  });

  $('.data-type select').change(function() {
    toggleFields(this)
  });
}); // END of document.ready

function takesPlaceholder(value) {
  return ['date', 'date/time', 'long-text', 'text', 'time'].includes(value);
}
function newNumber() {
  return $('.grabbable-number').length + 1;
}
function reNumber() {
  $('.grabbable-number').each(function(index) {
    $(this).text(index + 1);
  });
}
function setDefaultValues(field) {
  field.find('textarea').val('');
  field.find('.grabbable-number').text(newNumber());
  field.find('select').val('');
  field.find('input').val('');
}
function newNumber(){
  // the number of padded fields will the number of visible fields + 1,
  // which is what we want for the number of a new visible field.
  return $('.row.padded-field').length
}
function newID(fieldType){
  return 'form_draft_fields_attributes_' + newIndex() + '_' + fieldType
}
function newIndex(){
  return newNumber() - 1;
}
function toggleFields(dataField) {
  const dataType = dataField.value;
  const container = $(dataField).parents('.padded-field');
  if (takesPlaceholder(dataType) == true) {
    if (container.find('.placeholder').children().length == 0) {
      const newField = $('<input class="form-control" type="text" name="' + newName('placeholder') + '">')
      newField.appendTo(container.find('.placeholder'));
    }
  } else {
    container.find('.placeholder').children().remove();
  }
  if (dataType == 'options') {
    const newField = $('<textarea placeholder="add options separated by a comma" class="form-control" rows="4" name="' + newName('options') + '">');
    newField.appendTo(container.find('.options'));
  } else {
      container.find('.options').children().remove();
  }
  if (dataType == 'heading' || dataType == 'explanation') {
    container.find('.required').children().remove();
  } else {
    if (container.find('.required').children().length == 0) {
      const newField = $('<input type="checkbox" name="' + newName('required') + '">')
      newField.appendTo(container.find('.required'));
    }
  }
}
