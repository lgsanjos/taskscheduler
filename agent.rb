#!/usr/bin/ruby
#
require "rubygems"
require 'securerandom'
require 'json'
require 'date'

require 'net/http'
require 'uri'

def generate_token
  token = SecureRandom.hex(64)
  token = 'f9f899d42b498bdb760e559a6bcc13a1bd7de3c5339a6158418738cf1d2f6d9ffc6d8f98897c154f3055042e88217fb7a30e6939951cbba536516cc13c541f76'
  puts 'This is the agent token:'
  puts token
  puts 'Add this to link this agent with the server'
  puts ' ** This token will be regenerated when the agent restart'
  token
end

def request_data_from_server(token)
  request_url = URI.parse(@server_endpoint_prefix + "tasks/data/#{token}")
  response = Net::HTTP.get(request_url)
  JSON.parse(response)
end

def send_data_to_server(data, server_url)
  Net::HTTP.post_form(server_url, data).body
end

def should_execute_task(data)
  return true
end

def submit_start_task(token, task)
  endpoint = URI.parse(@server_endpoint_prefix + 'execution/start')
  send_data_to_server({ :task_id => task['id']  }, endpoint)
end

def submit_finished_task(exec_id)
  endpoint = URI.parse(@server_endpoint_prefix + 'execution/success')
  send_data_to_server({ :id => exec_id }, endpoint)
end

def submit_failure_task(exec_id)
  endpoint = URI.parse(@server_endpoint_prefix + 'execution/failed')
  send_data_to_server({ :id => exec_id }, endpoint)
end

puts 'Starting agent'

@server_endpoint_prefix = 'http://localhost:3000/'
puts "Server address: #{@server_endpoint_prefix}"
token = generate_token

tasks = request_data_from_server(token)
puts 'Tasks received from server'
puts JSON.pretty_generate(tasks)

begin
  tasks.each do |task|
   if should_execute_task(task)
      begin
        puts 'executing...'
        exec_id = submit_start_task(token, task)
        puts "  created execution id: #{exec_id}"
        system task['path']
      rescue
        submit_failure_task(exec_id)
        puts '  updated status to failed'
      ensure
        submit_finished_task(exec_id)
        puts ' updated status to success'
        puts 'done'
      end
      puts ''
    end
  end
  sleep 10
end while true
