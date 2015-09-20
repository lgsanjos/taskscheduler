# Task Scheduler

## About
====

This is a solution to trigger tasks around distributed computers, here on this *website* you can register new tasks  and monitor the execution of them here.

## How to:
====

### Download the agent
 * You can *download* the client agent clicking [here]('https://github.com/lgsanjos/taskscheduler/blob/master/agent.rb') or on the root path of this server.

### Install and run
 * Copy the agent.rb file to computer which will run the job
 * Make sure the client have have Ruby installed
 * Run on terminal '*ruby agent.rb*'

### Register a new task
 * Once you run the agent it will print on console a unique key
 * Go to new task page
 * Fill the key field with the client key
 * Fill the start, end date and the days of week that the job should execute>
 * On path field add the path of the script to be executed or a command line>

### Wait and see
 * On log page can see the status of all executions 
