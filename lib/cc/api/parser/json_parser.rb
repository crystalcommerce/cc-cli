module Cc
  module Api
    module Parser
      class JsonParser

        def self.vanilla_reduce array, cols
          result = []

          unless array.nil? 
            array.each do |j|
              hash = {}
              cols.each do |col|
                a = j
                col.split('.').each do |key|
                  a = a[key]
                end
                hash[col] = a || ""
              end
              result << hash
            end
          end
          result
        end 
      end
    end
  end
end


