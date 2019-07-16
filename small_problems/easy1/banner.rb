class Banner
  def initialize(message)
    @MAX_WIDTH = 80
    @width = message.length > @MAX_WIDTH ? @MAX_WIDTH : message.length
    @text = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    '+' + '-' * (width + 2) + '+'
  end

  def empty_line
    '|' + ' ' * (width + 2) + '|'
  end

  def message_line
    line = "| #{@text}"
    while width == @MAX_WIDTH && line.length <= @MAX_WIDTH + 2
      line << ' '
    end
    line << ' |'  
  end

  attr_reader :width, :text
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner2 = Banner.new('')
puts banner2