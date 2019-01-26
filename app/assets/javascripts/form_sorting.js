$( document ).ready( function() {
  $('.sortable').sortable({
    stop: function() {
      reAttribute();
    },
  });

  $('#add-new').click(function() {
    const newField = $('.hidden').find('.row.padded-field').clone(true).removeClass('hidden');
    newField.appendTo('.container.sortable');
    reAttribute();
  });

  $('.remove').click(function() {
    const parentField = $(this).parents('.row.padded-field');
    parentField.remove();
    reAttribute(); // This one works.
  });

  $('.data-type select').change(function() {
    toggleFields(this);
    reAttribute();
  });
}); // END of document.ready

function takesPlaceholder(value) {
  return ['date', 'date/time', 'long-text', 'text', 'time'].includes(value);
}
function reAttribute() {
  $('.number input:visible').each(function(index) {
    $(this).attr('name', newName('number', index))
    $(this).attr('id', 'form_draft_fields_attributes_' + index + '_number');
    $(this).val(index + 1);
    const parentField = $(this).parents('.row.padded-field');
    [
      '.prompt textarea',
      '.placeholder input',
      '.required input',
      '.data-type select',
      '.options textarea'
    ].forEach(function(className){
      const name = className.match(/.\w+/)[0].slice(1);
      parentField.find(className).attr('name', newName(name, index));
      parentField.find(className).attr('id', newID(name, index));
    })
  });
}
function newName(fieldType, index){
  return 'form_draft[fields_attributes][' + index + '][' + fieldType + ']';
}
// the number of padded fields will the number of visible fields + 1,
// which is what we want for the number of a new visible field.
function newID(fieldType, index){
  return 'form_draft_fields_attributes_' + index + '_' + fieldType
}
function toggleFields(dataField) {
  const dataType = dataField.value;
  const container = $(dataField).parents('.padded-field');
  if (takesPlaceholder(dataType) == true) {
    if (container.find('.placeholder').children().length == 0) {
      const newField = $('<input class="form-control" type="text">')
      newField.appendTo(container.find('.placeholder'));
    }
  } else {
    container.find('.placeholder').children().remove();
  }
  if (dataType == 'options') {
    const newField = $('<textarea placeholder="add options separated by a comma" class="form-control" rows="4">');
    newField.appendTo(container.find('.options'));
  } else {
      container.find('.options').children().remove();
  }
  if (dataType == 'heading' || dataType == 'explanation') {
    container.find('.required').children().remove();
  } else {
    if (container.find('.required').children().length == 0) {
      const newField = $('<input type="checkbox" name=">')
      newField.appendTo(container.find('.required'));
    }
  }
}
