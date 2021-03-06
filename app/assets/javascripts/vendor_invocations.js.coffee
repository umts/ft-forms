$(document).ready ->
  $('.datepicker').datetimepicker
    format: 'dddd, MMMM D, YYYY'
    changeMonth: true
    changeYear: true
    yearRange: 'c-5:c+5'

  $('.datetimepicker').datetimepicker
    format: 'dddd, MMMM D, YYYY, h:mm a'
    formatTime: 'h:mm a'
    step:       15
    defaultDate: null

  $.datetimepicker.setDateFormatter
    parseDate: (date, format) ->
      d = moment(date, format)
      if d.isValid() then d.toDate() else false
    formatDate: (date, format) ->
      moment(date).format format

  $('.timepicker').datetimepicker
    datepicker:false,
    format:'h:mm A',
    formatTime:'h:mm A',
    step: 5
return
