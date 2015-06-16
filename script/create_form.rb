# Invoke this file using 'rails runner script/create_form.rb'

require 'csv'

ActiveRecord::Base.transaction do
  form = Form.first_or_create! name: 'Meet & Greet Request Form'
  form.fields.delete_all
  CSV.parse(<<FIELDS, headers: true, col_sep: ';').each do |row|
number;data_type;prompt;required
1;heading;UMass Department;false
2;text;Department name;true
3;text;Contact person;true
4;text;Email;true
5;text;Phone;true
6;text;Fax;false
7;heading;Passenger Information;false
8;number;Number of passengers;true
9;text;Passenger name(s);true
10;text;Cell phone(s);false
11;explanation;Although a passenger cell phone is not required, it is the best way for us to ensure that we can quickly and easily connect with our passenger(s). Please consider providing one.;false
12;heading;Trip Information;false
14;explanation;All vehicle requests are subject to availability.;false
15;date/time;Pickup date and time;true
16;text;Pickup location;true
17;text;Destination;true
18;explanation;Please provide any pertinent flight, train, or bus information below.;false
19;text;Flight number;false
20;text;Airline or provider;false
21;time;Arrival/departure time;false
22;heading;Return Trip Information (optional);false
24;explanation;All vehicle requests are subject to availability.;false
25;date/time;Pickup date and time;false
26;text;Pickup location;false
27;text;Destination;false
28;explanation;Please provide any pertinent flight, train, or bus information below.;false
29;text;Flight number;false
30;text;Airline or provider;false
31;time;Arrival/departure time;false
32;heading;Notes;false
33;long-text;Notes and special requests;false
FIELDS
    attrs = row.to_hash.merge form_id: form.id
    Field.create! attrs
  end
  # Couldn't make options work with CSV, so create manually
  Field.create! form_id: form.id, number: 13, data_type: 'options', prompt: 'Desired vehicle type', required: true, options: ['Sedan', 'Van']
  Field.create! form_id: form.id, number: 23, data_type: 'options', prompt: 'Desired vehicle type', required: false, options: ['Sedan', 'Van']
end
