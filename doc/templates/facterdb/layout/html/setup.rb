# frozen_string_literal: true

include T('default/layout/html')

def layout
  @nav_url = url_for_list((defined?(@file) && @file) ? 'file' : 'class')

  @path =
    if !object || object.is_a?(String)
      nil
    elsif defined?(@file) && @file
      @file.path
    elsif !object.is_a?(YARD::CodeObjects::NamespaceObject)
      object.parent.path
    else
      object.path
    end

  erb(:layout)
end
