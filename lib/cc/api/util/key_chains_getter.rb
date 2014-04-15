module Cc
  module Api
    module Util
      class KeyChainsGetter
        @@key_chains = []

        def self.get_key_chains elements, string, ignores=nil
          puts "\navailable columns\n===================="
          self.key_chains elements, string, ignores
          puts "\nUSAGE:"
          puts "--cols #{[@@key_chains.sample, @@key_chains.sample, @@key_chains.sample].join(',')}"
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

        private

        def self.key_chains elements, string, ignores=nil
          return unless elements

          if elements.class == Hash
            elements.each do |key, array|
              self.key_chains array, string + key.to_s + '.', ignores
            end
          elsif elements.class == Array
            begin
              elements.first.each do |key, array|
                self.key_chains array, string + '<index>.' + key.to_s + '.', ignores
              end
            rescue
              return
            end
          else
            if ignores
              ignores.each do |ignore|
                if string[0...-1].match ignore
                  unless @@key_chains.include? ignore + '.*'
                    puts ignore + '.*' 
                    @@key_chains << ignore + '.*'
                  end
                else
                  @@key_chains << string[0...-1]
                  puts string[0...-1]
                end
              end
            else
              puts string[0...-1]
              @@key_chains << string[0...-1]
            end
          end
        end

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

