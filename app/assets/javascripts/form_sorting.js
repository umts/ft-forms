$( document ).ready( function() {
  $('.sortable').sortable({
    stop: function(event, ui) {
      reNumber();
    },
  });

  $('#add-new').click(function() {
    var newField = $('.row.padded-field').last().clone(true);
    appendField(newField, setDefaultValues);
  });

  $('.remove').click(function() {
    var fields = $('.row.padded-field');
    var parentField = $(this).parents('.row.padded-field');
    if (fields.length > 1) {
      parentField.remove();
    } else { // If they want to remove the last field, just empty it instead.
      setDefaultValues(parentField);
    }
    reNumber();
  });

  $('.data-type select').change(function() {
    var placeholder = $(this).parents('.padded-field').find('.placeholder');
    var options = $(this).parents('.padded-field').find('.options');
    var value = this.value;
    if (takesPlaceholder(value) == true) {
      if (placeholder.children().length == 0) {
        $('<input type="text" value="">').appendTo(placeholder);
      }
    } else {
      placeholder.children().remove();
    }
    if (value == 'options') {
      var optionsField = $('<textarea class="form-control" rows="4">');
      optionsField.appendTo(options);
    } else {
      options.children().remove();
    }
  });

  // haha formform
  $('form#form').on('ajax:before', function(event, xhr, settings) {
    return false;
  });

  $('form#form').submit(function(e) {
    e.preventDefault;
    fields = $('.padded-field');
    var formData = {
      name: $('[name="form_draft[name]"]').val(),
      email: $('[name="form_draft[email]"]').val(),
      reply_to: $('[name="form_draft[reply_to]"]').val(),
      fields: extractFieldData(fields),
    };
    var data = {form_draft: formData};
    var ID = $('form').data('id');
    let URL = '/form_drafts/';
    var method = 'POST'; // create
    if (ID != undefined) {
      URL = '/form_drafts/' + ID;
      method = 'PUT'; // update
    }
    $.ajax({
      url: URL,
      method: method,
      data: data,
    }).done(function() {
      document.location.href = '/form_drafts/' + ID;
    });
  });
}); // END of document.ready

function takesPlaceholder(value) {
  return ['date', 'date/time', 'long-text', 'text', 'time'].includes(value);
}

function extractFieldData(fields) {
  var allFieldData = {};
  $('.padded-field').each( function(index) {
    var fieldData = {};
    fieldData['number'] = index + 1;
    fieldData['prompt'] = $(this).find('textarea').val();
    fieldData['placeholder'] = $(this).find('.placeholder').val();
    fieldData['required'] = $(this).find('.required :checkbox').prop('checked');
    fieldData['data_type'] = $(this).find('.data-type select').val();
    allFieldData[index] = fieldData;
    // TODO: $(this).find('.options')
  });
  return allFieldData;
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

// $('.options').children('textarea').val() is how you grab options
