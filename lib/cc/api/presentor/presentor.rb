require 'command_line_reporter'

module Cc
  module Api
    module Presentor
      class Tabler
        include CommandLineReporter

        def present result, column_width, column_padding, offset, limit
          unless result.empty?
            table :border => true do
              row do
                result.first.collect{|k,v| k}.each do |col|
                  column(col, align: 'left', width: column_width || 30, padding: column_padding || 5)
                end
              end

              result.drop(offset || 0).each_with_index do |res, i|
                break if limit && i > limit-1
                row do
                  res.collect{|k,v| v}.each do |val|
                    column(val)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

