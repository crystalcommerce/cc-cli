module Cc
  module Api
    module Util
      class KeyChainsGetter
        def self.get_key_chains elements, string
          return unless elements

          if elements.class == Hash
            elements.each do |key, array|
              self.get_key_chains array, string + key.to_s + '.'
            end
          elsif elements.class == Array
            begin
              elements.first.each do |key, array|
                self.get_key_chains array, string + '<index>.' + key.to_s + '.'
              end
            rescue
              return
            end
          else
            puts string[0...-1]
          end
        end

        def self.get_target_array hash, target, id=nil
          begin
            a = hash
            target.split('.').each do |key|
              if key == 'FIRST'
                a = a[0]
              elsif key == 'PRODUCT_ID'
                a = a[id]
              else
                a = a[key]
              end
            end
            a
          rescue
            puts "Target not found."
          end
        end

        protected

        def self.all_elements_are_leaf array #elements' class are neither Array nor Hash
          array.each do |a|
            return false if a.class == Array || a.class == Hash
          end

          return true
        end
      end
    end
  end
end

