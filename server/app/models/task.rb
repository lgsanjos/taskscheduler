class Task < ActiveRecord::Base
  has_many :task_executions

  validates :name, length: { in: 3..100, message: 'must be larger than 3 char and smaller than 100' }
  validates :path, presence: { message: 'or shell script must be specified' }
  validates :days, format: { with:  /\A(mon|tue|wed|thu|fri|sat|sun){1}(\-(mon|tue|wed|thu|fri|sat|sun)){1,6}\z/, 
    message: "should contains only the first three inital letters days of week separated by '-', at most specify 7 days. Example: mon-tue-wed-thu-fri-sat-sun"
  }
  validates :key, presence: { message: 'must be specified. You can find the key when initialize the agent.'}
end
