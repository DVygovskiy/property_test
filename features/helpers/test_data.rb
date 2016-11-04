require 'ffaker'

class TestData
    include FFaker

    def self.generate(text)
        if text.include? "email"
            data = FFaker::Internet.email
        elsif text.include? "first"
            data = FFaker::Name.first_name
        elsif text.include? "last"
            data = FFaker::Name.last_name
        elsif text.include? "password"
            data = FFaker::Internet.password(max_length=9)
        else
          data = FFaker::Lorem.phrase(max_length=10)
        end
        return data
    end

end



