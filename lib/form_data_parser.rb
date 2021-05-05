# frozen_string_literal: true

class FormDataParser
  attr_reader :prompts, :responses

  def initialize(data)
    @data = data
    @prompts = []
    @responses = []
  end

  # data is a hash, where the keys come in three forms:
  # 'field_:number', whose value will be the response to a form field;
  # 'prompt_:number', whose value is the prompt of the field; or
  # 'heading_:number', whose valie is the heading text.
  def process!
    @data.each do |field, value|
      data_type = field.split('_').first.to_sym
      number = field.split('_').last.to_i
      store_date(data_type, number, value)
    end
    prompts.compact.zip responses.compact
  end

  private

  def store_date(data_type, number, value)
    case data_type
    when :field
      @responses[number] = value
    when :prompt
      @prompts[number] = value
    when :heading
      @prompts[number] = value
      @responses[number] = :heading
    end
  end
end
