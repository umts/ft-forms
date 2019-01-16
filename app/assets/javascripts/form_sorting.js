$( document ).ready( function() {
  $('.sortable').sortable({
    stop: function() {
      reNumber();
    },
  });

  $('#add-new').click(function() {
    const newField = $('.hidden').find('.row.padded-field').clone(true).removeClass('hidden');
    newField.find('.grabbable-number input').attr('name', newName('number'));
    newField.find('.grabbable-number input').attr('id', newID('number'));
    newField.find('.grabbable-number input').val(newNumber());
    newField.appendTo('.container.sortable');
  });

  $('.remove').click(function() {
    const parentField = $(this).parents('.row.padded-field');
    parentField.remove();
    reNumber();
  });

  $('.data-type select').change(function() {
    toggleFields(this)
  });
}); // END of document.ready

function takesPlaceholder(value) {
  return ['date', 'date/time', 'long-text', 'text', 'time'].includes(value);
}
function reNumber() {
  $('.number input:visible').each(function(index) {
    $(this).attr('name', 'form_draft[fields_attributes][' + index + '][number]' );
    $(this).attr('id', 'form_draft_fields_attributes_' + index + '_number');
    $(this).val(index + 1);
  });
}
function newName(fieldType){
  return 'form_draft[fields_attributes][' + newIndex() + '][' + fieldType + ']';
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
