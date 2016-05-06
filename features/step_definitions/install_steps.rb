require 'open3'

## Background
# To run the server
Given(/^I have a running server$/) do
  output, error, status = Open3.capture3 "vagrant reload"
  expect(status.success?).to eq(true)
end

# To provision the server
And(/^I provision it$/) do
  output, error, status = Open3.capture3 "vagrant provision"

  puts output
  puts error
  expect(status.success?).to eq(true)
end

## Elasticsearch scenario
When(/^I install elasticsearch$/) do
 cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elasticsearch.yml"

  output, error, @status = Open3.capture3 "#{cmd}"
  
end

Then(/^it should be successful$/) do
  expect(@status.success?).to eq(true)
end

And(/^([^"]*) should be running$/) do |pkg|
  case pkg
  when 'elasticsearch', 'logstash', 'kibana'
    output, error, status = Open3.capture3 "vagrant ssh -c 'sudo service #{pkg} status'"

    puts output
    expect(status.success?).to eq(true)
    expect(output).to match("#{pkg} is running")
  else
    raise 'Not Implemented'
  end
end

And(/^it should be accepting connections on port ([^"]*)$/) do |port|
  output, error, status = Open3.capture3 "vagrant ssh -c 'curl -f http://localhost:#{port}'"

  expect(status.success?).to eq(true)
end

## Logstash scenario
When(/^I install logstash$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.logstash.yml"

  output, error, @status = Open3.capture3 "#{cmd}"
end

## Kibana scenario
When(/^I install kibana$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.kibana.yml"
  
  output, error, @status = Open3.capture3 "#{cmd}"
end

# When(/^I install logstash-input-heroku$/) do
#   cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.heroku.yml"
  
#   output, error, @status = Open3.capture3 "#{cmd}"
#   puts output
#   puts error
# end

# And(/^the plugin should be installed on kibana$/) do
#   cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.heroku-test.yml"

#   output, error, status = Open3.capture3 "#{cmd}"
#   puts output
#   puts error
#   expect(status.success?).to eq(true)
# end
