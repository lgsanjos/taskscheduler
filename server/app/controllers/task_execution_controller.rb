class TaskExecutionController < ApplicationController

  skip_before_filter :verify_authenticity_token
  
  # POST /task_execution/start_execution
  def start_execution
    task_id = params[:task_id]
    
    exec = TaskExecution.new
    exec.task = Task.find(task_id)
    exec.start = DateTime.now
    exec.status = 'Started'
    exec.save!
    exec.reload
    render :text => exec.id, :status => :ok, content_type: "text/html"
  end

  # POST /task_execution/failed_execution
  def failed_execution
    task_id = params[:id]
    
    exec = TaskExecution.find(task_id)
    exec.end = DateTime.now
    exec.status = 'Failed'
    exec.save!
    head :ok, content_type: "text/html"
  end

  # POST /task_execution/success_execution
  def success_execution
    task_id = params[:id]
    
    exec = TaskExecution.find(task_id)
    exec.end = DateTime.now
    exec.status = 'Success'
    exec.save!
    head :ok, content_type: "text/html"
  end

  # GET /
  def index
    @executions = TaskExecution.all.reverse
  end

end
