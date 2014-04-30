module Cc
  module Api
    module Parser
      class JsonParser
        def self.vanilla_reduce(array, cols)
          result = []

          unless array.nil? 
            array.each do |j|
              hash = {}
              cols.each do |col|
                a = j
                col.split('.').each do |key|
                  begin 
                    a = a[self.is_numeric?(key) ? key.to_i : key]
                  rescue NoMethodError 
                    break
                  end
                end
                hash[col] = a || ""
              end
              result << hash
            end
          end
          result
        end

        private

        def self.is_numeric?(i)
          /^\d+$/ === i
        end
      end
    end
  end
end


