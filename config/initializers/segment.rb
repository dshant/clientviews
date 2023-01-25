Segment = SimpleSegment::Client.new(
  write_key: 'd7Ji7DXyfa192C1Ne8seOUBpZtXWZ5QR', # required
  on_error: proc { |error_code, error_body, exception, response|
    puts "#{error_code}, #{error_body}, #{exception}, #{response}"
  }
)
