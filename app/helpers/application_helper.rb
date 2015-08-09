# coding: utf-8
require 'ostruct'

module ApplicationHelper
  def resource
    instance_variable_get('@' + controller_name.singularize)
  end

  def resource_model
    controller_name.singularize.camelize.constantize
  end

  def collection
    instance_variable_get('@' + controller_name)
  end

  def field_set(*args, &block)
    options = args.extract_options!
    legend = args.shift || options[:legend]
    content_tag(:fieldset) do
      html = ''.html_safe
      html << content_tag(:legend, legend) if legend
      html << capture(&block)
      html
    end
  end

  def show_grid(name = nil)
    render((name ? "#{name}_grid" : 'grid'), collection_grid: instance_variable_get("@#{name}_grid"))
  end

  def action_title
    @title_interpolations ||= resource.attributes.symbolize_keys if resource
    options = @title_interpolations || {}
    options[:default] = []
    options[:default] << (action_name == 'index' ? controller_name.to_s.humanize : (action_name == 'new') ? "New #{controller_name.to_s.singularize}" : "#{action_name.humanize}: %{name}")
    I18n.translate("actions.#{controller_path}.#{action_name}", options)
  end

  def nested_fields(items, f)
    item = items.to_s.singularize
    content_tag(:div, id: items, class: 'panel') do
      f.simple_fields_for(:farms) do |nested|
        render("#{item}_fields", f: nested)
      end +
        content_tag(:div, class: 'links') do
          link_to_add_association("add_#{item}".tl, f, items)
        end
    end
  end

  def human_date(made_on)
    today = Date.today
    # if made_on == today
    #   "date.today".t
    # elsif made_on == today - 1
    #   "date.yesterday".t
    # elsif made_on == today + 1
    #   "date.tomorrow".t
    #   els
    if made_on - today < 1.year
      made_on.l(format: :short)
    else
      made_on.l(format: :long)
    end
  end

  def human_period(started_at, stopped_at)
    started_on = started_at.to_date
    stopped_on = stopped_at.to_date
    text = ''
    if started_on == stopped_on
      text << human_date(started_on).strip
      text << ' de '
      text << started_at.l(format: '%H:%M')
      text << ' à '
      text << stopped_at.l(format: '%H:%M')
    else
      text << 'du '
      text << human_date(started_on).strip
      text << ' à '
      text << started_at.l(format: '%H:%M')
      text << ' au '
      text << human_date(stopped_on).strip
      text << ' à '
      text << stopped_at.l(format: '%H:%M')
    end
    content_tag(:span, text.html_safe, class: :date)
  end

  class Tabber
    attr_reader :tabs

    def initialize(id, template)
      @id = id
      @template = template
      @tabs = []
    end

    def tab(name, options = {}, &block)
      content = @template.capture(&block)
      if options[:force] || content.present?
        @tabs << OpenStruct.new(id: name, label: options[:label] || name.tl, content: content, active: @tabs.size.zero?)
      end
      nil
    end
  end

  def tabbox(id)
    tabber = Tabber.new(id, self)
    yield tabber
    render('tabbox', tabber: tabber) if tabber.tabs.any?
  end
end
