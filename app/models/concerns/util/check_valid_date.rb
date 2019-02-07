# frozen_string_literal: true

module Util
  module CheckValidDate
    def self.is_valid_date(p_date)
      p_date.to_date
      Date.parse(p_date)
    rescue StandardError
      nil
      end
    end
end
