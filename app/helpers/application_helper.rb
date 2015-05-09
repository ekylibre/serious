module ApplicationHelper

  def resource
    instance_variable_get('@' + self.controller_name.singularize)
  end

  def collection
    instance_variable_get('@' + self.controller_name)
  end

  def field_set(*args, &block)
    options = args.extract_options!
    legend = args.shift || options[:legend]
    content_tag(:fieldset) do
      html = "".html_safe
      html << content_tag(:legend, legend) if legend
      html << capture(&block)
      html
    end
  end

  def show_grid(name, *args)
    render "#{name}_grid", collection_grid: instance_variable_get("@#{name}_grid")
  end
  
end
