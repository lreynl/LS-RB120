require 'Date'

class SecretFile
  #attr_reader :data

  def data
    @logger.create_log_entry
    @data
  end

  def initialize(secret_data, logger)
    @logger = logger
    @data = secret_data
  end

  def access_log
    @logger.log
  end
end

class SecurityLogger
  attr_reader :log
  def initialize
    @log = []
  end
  
  def create_log_entry
    @log << "Read access at #{DateTime.now}"
    # ... implementation omitted ...
  end
end

file = SecretFile.new("Top secret", SecurityLogger.new)
puts file.data
puts file.data
puts file.data
puts file.access_log
