$(document).ready ->
  $('.datepicker').datepicker
    altFormat: 'DD, MM dd, yy' 
    changeMonth: true
    changeYear: true
    yearRange: 'c-5:c+5'

  $('.datetimepicker').datetimepicker
    format: 'l, F j, Y g:i a' 
    step:       15
    defaultDate: null

  $('.timepicker').timepicker
    timeFormat: 'g:i a'
return
