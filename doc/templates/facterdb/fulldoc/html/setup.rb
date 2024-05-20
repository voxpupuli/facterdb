# frozen_string_literal: true

include T('default/fulldoc/html')

def stylesheets_full_list
  # Load the existing stylesheets while appending the custom one
  super + %w[css/vox.css]
end
