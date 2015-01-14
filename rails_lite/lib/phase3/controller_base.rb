require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'
#require 'byebug'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name) #template_name is e.g. "show"
      controller_name = self.class.to_s.underscore
      template = File.read("views/#{controller_name}/#{template_name}.html.erb")
      content = ERB.new(template).result(binding)
      #debugger
      render_content(content, "text/html") #not variable for now, @req params might have it...
    end
  end
end
