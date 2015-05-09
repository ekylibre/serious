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

  def show_grid(name = nil)
    render((name ? "#{name}_grid" : "grid"), collection_grid: instance_variable_get("@#{name}_grid"))
  end

  def action_title
    if resource
      @title_interpolations ||= resource.attributes.symbolize_keys
    end
    options = @title_interpolations || {}
    options[:default] = []
    options[:default] << (action_name == "index" ? controller_name.to_s.humanize : action_name == "new" ? "New #{controller_name.to_s.singularize}" : "#{action_name.humanize}: %{name}")
    I18n.translate("actions.#{controller_path}.#{action_name}", options)
  end

end
