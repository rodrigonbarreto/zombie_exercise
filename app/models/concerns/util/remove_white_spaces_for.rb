module Util
  module RemoveWhiteSpacesFor
    def before_validation_remove_white_spaces_for(*fields)
      before_validation do
        fields.each do |field_name|
          if public_send(field_name).present?
            public_send "#{field_name}=", public_send(field_name).squish
          end
        end
      end
    end
  end
end
