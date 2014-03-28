module Cc
  module Api
    module Util
      class KeyChainsGetter
        def self.get_key_chains hashes, level, string
          hashes.map.each_with_index do |k, i| 
            if k.class != Hash && k.class != Array
              spaces = ""
              (0..level).each do 
                spaces = spaces +  " "
              end
              if i == 1
                puts string[0...-1] if i == 1 
              end
              string = string + k.to_s + "."
            else
              self.get_key_chains k, level + 1, string
            end
          end
        end
      end
    end
  end
end

