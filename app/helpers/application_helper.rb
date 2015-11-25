module ApplicationHelper
  # Returns the needed CSS class on the text field tag
  # based on the data type of the field.
  def input_class(data_type)
    case data_type
    when 'date' then 'datepicker'
    when 'date/time' then 'datetimepicker'
    when 'text' then nil
    when 'time' then 'timepicker'
    end
  end

  # data is a hash, where the keys come in two forms:
  # 'field_:number', whose value will be the response to a form field;
  # 'prompt_:number', whose value is the prompt of the field.
  # We return them both, for mailer purposes.
  def parse_form_data(data)
    prompts = []
    responses = []
    data.each do |k, v|
      data_type, number = k.split '_'
      case data_type
      when 'field'
        responses[number.to_i] = v
      when 'prompt'
        prompts[number.to_i] = v
      when 'header'
        # okay at this point it's different what do
        # upcase? this method just returns an array of
        # undifferentiated strings. must do something else.
        # Perhaps an array of arrays much like in jobapps,
        # and then I can do something to an array that contains
        # a header.. but before it becomes just another string.
        prompts[number.to_i] = v
      end
    end
    prompts.compact.zip responses.compact
  end
end
