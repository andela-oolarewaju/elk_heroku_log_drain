require 'open3'

Given(/^I have a running server$/) do
  output, error, status = Open3.capture3 "vagrant reload"

  expect(status.success?).to eq(true)
end

And(/^I provision it$/) do
  output, error, status = Open3.capture3 "vagrant provision"
  expect(status.success?).to eq(true)
end

When(/^I install elasticsearch$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elasticsearch.yml"

  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^it should be successful$/) do
  expect(@status.success?).to eq(true)
end

And(/^([^"]*) should be running$/) do |pkg|
  case pkg
  when 'elasticsearch', 'logstash', 'kibana', 'nginx'
    output, error, status = Open3.capture3 "vagrant ssh -c 'sudo service #{pkg} status'"

    expect(status.success?).to eq(true)
    expect(output).to match("#{pkg} is running" || "#{pkg} start/running" )
  else
    raise 'Not Implemented'
  end
end

And(/^it should be accepting connections on port ([^"]*)$/) do |port|
  output, error, status = Open3.capture3 "vagrant ssh -c 'curl -f http://localhost:#{port}'"

  expect(status.success?).to eq(true)
end

When(/^I install logstash$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.logstash.yml"

  output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^logstash etc directory should be present$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/logstash/ | grep conf.d'"

  expect(output).to match("conf.d")
end

When(/^I install kibana$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.kibana.yml"

  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install heroku$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.heroku.yml"
  
  output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^it should be running on kibana$/) do
  cmd = "opt/logstash/bin/plugin list | grep logstash-input-heroku"

  output, error, status = Open3.capture3 "#{cmd}"
  
  expect(output).to match("logstash-input-heroku")
end

When(/^I install nginx$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml"
  
  output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^I create ssl certificate$/) do
  output, error, status = Open3.capture3 "vagrant ssh -c 'ls /etc/nginx/ssl | grep server'"
  
  expect(output).to match("server.*")
end

And(/^I create stark-wildwood folder$/) do
  output, error, status = Open3.capture3 "vagrant ssh -c 'ls /etc/nginx/sites-available | grep stark-wildwood'"
  
  expect(output).to match("stark-wildwood")
end

When(/^I install apache2-utils$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml --tags 'apache2_utils_setup'"
  
  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install python-passlib$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml --tags 'passlib_setup'"
  
  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I create kibana.htpassword$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'kibana.htpassword'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^kibana.htpassword file should exist$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/conf.d/ | grep kibana.htpasswd'"

  expect(output).to match("kibana.htpasswd")
end

When(/^I create kibana-write.htpassword$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elk.yml --tags 'kibanawrite.htpassword'"

  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^kibana-write.htpassword file should exist$/) do
  output, error, status = Open3.capture3 "unset RUBYLIB; vagrant ssh -c 'ls /etc/nginx/conf.d/ | grep kibana-write.htpasswd'"

  expect(output).to match("kibana-write.htpasswd")
end


