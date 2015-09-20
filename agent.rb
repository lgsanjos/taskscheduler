#!/usr/bin/ruby
#
require "rubygems"
require 'securerandom'
require 'json'
require 'date'
require 'time'

require 'net/http'
require 'uri'

def read_key_from_file
  file_name = './key.id'

  if File.exist?(file_name) 
    key = File.read(file_name) 
    puts "Keep using key = #{key}"
    return key 
  end

  new_key = generate_key
  File.write(file_name, "#{new_key}")
  new_key
end

def generate_key
  token = SecureRandom.hex(64)
  puts 'Generating new Key:'
  puts " New key = #{token}"
  puts '  Use this key to link this agent with the server'
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

def can_execute_today(days_allawed)
  today = DateTime.now.strftime("%A").downcase.slice(0..2)  
  today_is_allowed = days_allawed.include? today

  puts '  Check days allowed:'
  if (today_is_allowed)
    puts "  allowed!"
  else
    puts "  not allowed!"
  end

  puts "    Allowed: #{days_allawed}"
  puts "    Today = #{today}"

  return true if today_is_allowed
  false
end

def can_execute_right_now(min_time, max_time)
  time = DateTime.now.to_time
  right_now_is_allowed = time > min_time and time < max_time

  puts 'Check time in range:'
  if (right_now_is_allowed)
    puts "  allowed!"
  else
    puts "  not allowed!"
  end

  puts "    allowed: #{min_time.strftime("%H:%M:%S")} and #{max_time.strftime("%H:%M:%S")}"
  puts "    right now: #{time.strftime("%H:%M:%S")}"

  return true if right_now_is_allowed
  false
end


def should_execute_task(data)

  min_time = Time.parse(data['start'])
  max_time = Time.parse(data['end'])

  puts "Task: #{data['name']}"
  return false unless can_execute_today(data['days'])
  puts " "
  return false unless can_execute_right_now(min_time, max_time)
  puts " "

  true
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
token = read_key_from_file

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
        system task['path'] or raise 'Something went wrong :/'
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
