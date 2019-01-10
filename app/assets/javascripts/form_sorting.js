$( document ).ready( function() {
  $('.sortable').sortable({
    stop: function() {
      reNumber();
    },
  });

  $('#add-new').click(function() {
    const newField = $('.row.padded-field').last().clone(true);
    appendField(newField, setDefaultValues);
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
    const placeholder = $(this).parents('.padded-field').find('.placeholder');
    const options = $(this).parents('.padded-field').find('.options');
    const value = this.value;
    if (takesPlaceholder(value) == true) {
      if (placeholder.children().length == 0) {
        $('<input type="text" value="">').appendTo(placeholder);
      }
    } else {
      placeholder.children().remove();
    }
    if (value == 'options') {
      const optionsField = $('<textarea class="form-control" rows="4">');
      optionsField.appendTo(options);
    } else {
      options.children().remove();
    }
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
function appendField(field, callback) {
  callback(field);
  field.appendTo('.container.sortable');
}
