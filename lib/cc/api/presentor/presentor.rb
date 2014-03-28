require 'command_line_reporter'

module Cc
  module Api
    module Presentor
      class Tabler
        include CommandLineReporter

        def present result, column_width, column_padding
          unless result.empty?
            table :border => true do
              row do
                result.first.collect{|k,v| k}.each do |col|
                  column(col, align: 'left', width: column_width || 30, padding: column_padding || 5)
                end
              end

              result.each do |res|
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

