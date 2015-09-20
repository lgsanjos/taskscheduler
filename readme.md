# Task Scheduler

## About
====
  It's a Task Scheduler system, install agents on computers that should execute some bash script and the server will manage those agents and store information about their execution.

  This VERY far from a real solution, it's an exercise mostly to practice Ruby. it was based on a project required from a job interview.

## Assumptions
====

### Site
 * Website UI should be responsive
 * No authentication is required to consume the API or the website
 * The website does not refresh automatically when receives updates from the agents

### Agent
 * Agent should be a stand alone
 * When installed the admin will add the Agent to auto start as a background job
 * The Agent will execute and reexecute the same task time after time until the conditions of days of week or start/end time block
 * The Agent requests task information and keep those data in memory, it will be refresh once every hour or when the agent is reinitialized

## Room to improve
====
 * Agent could send the token automatically to server
 * Server could have separated models for clients and tasks and keep a relationship between them
 * Sleep time in the agent loop and the server address could be passed as parameters to the Agent
 * Task could have a limit of executions per day, so if the execution is fast it doesn't trigger multiple times in a row
 * Task could have a check condition to run the task, so it could avoid running the task without necessity
 * Task execution could have a timeout
 * Website could update log status as it receives update from agents without the need of user refresh the page
 * On website the user could abort the job's execution
 * On the website the user could see the job's output 

## Design
====

### Technical
 * The website is a standart Ruby on Rails application, based on MVC architecture
 * Database is SQLite 3
 * It was created two tables on database, one for task and agent data another for each task execution data
 * The agent is a standalone script with no extra dependency

### Solution
 * The agent will request to server a list of tasks that it should execute
 * The server will provide all tasks based on agent's key
 * The agent keeps running in a loop that every 10 seconds tries to run each task
 * Before running a task it verifies if the week day is valid and the time is in the right interval
 * If all the conditions attends, it executes and submits the result to the server
 * If the execution of the command returns any exit code different than 0 it is considered a failure

## Setup
====

### The server
 * Make sure you have Ruby 2 or higher installed
 * Run on terminal 'bundle install' 
 * To create a SQLite DB run 'rake db:create' 
 * Then 'rake db:migrate'
 * To start the server run 'rails s'
 * Open on your browser the address 'localhost:3000'

### The agent
 * You can find the agent.rb file on the root of this folder 
 * Copy the agent.rb file to computer which will run the job
 * Run on terminal 'ruby agent.rb'
 * Once you run the agent it will print on console a unique key, it will be stored in a file named key.id and will be reused

### Register a task
 * Go to localhost:3000
 * Click on the Tasks link on the header
 * Then click on new Task button
 * Fill the key field with the client generated key
 * Fill the start, end date and the days of week that the job should execute
 * On path field add the path of the script to be executed or a command line
 * Click on save

### Wait and see 
 * On log page can see the status of all executions 
