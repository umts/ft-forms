module ApplicationHelper
  # Returns the needed CSS class on the text field tag
  # based on the data type of the field.
  def input_class(data_type)
    case data_type
    when 'date'      then 'datepicker'
    when 'date/time' then 'datetimepicker'
    when 'text'      then  nil
    when 'time'      then 'timepicker'
    end
  end
end
