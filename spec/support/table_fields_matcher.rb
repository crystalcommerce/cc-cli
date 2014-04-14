# -*- coding: utf-8 -*-
RSpec::Matchers.define :have_ascii_table_row do |expected|
  parse = ->(actual) {
    actual.split("\n").map(&:chomp).map do |line|
      line.scan(/([^┃]+)┃/).flatten.map(&:strip)
    end
  }
  match do |actual|
    parse[actual].include?(expected)
  end

  failure_message_for_should do |actual|
    lines = parse[actual].reject(&:empty?)
    "expected to find #{expected.inspect} in #{lines.map(&:inspect).join("\n")}"
  end
end
