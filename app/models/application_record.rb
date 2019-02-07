class ApplicationRecord < ActiveRecord::Base
  extend Util::RemoveWhiteSpacesFor
  self.abstract_class = true
end
