# frozen_string_literal: true

class Utils
  def self.log(hash)
    puts JSON.generate(hash)
  end
end
