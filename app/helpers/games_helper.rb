module GamesHelper
  def view_mode
    session[:view_mode] || :map
  end

  def strat(x, y, width, height, thickness, options = {})
    depth = options.delete(:depth) || 0
    depth += thickness
    parallelo(x, y, width, height, thickness, options.merge(altitude: -1 * depth, top: false))
  end

  def parallelo(x, y, width, height, thickness, options = {})
    altitude = options.delete(:altitude) || 0
    color = Color::RGB.by_hex(options[:fill][1..6])
    svg = ''.html_safe
    svg << tag(:path, options.merge(d: "M #{x + width - altitude} #{y - altitude} L #{x + width - altitude - thickness} #{y - altitude - thickness} L #{x + width - altitude - thickness} #{y + height - altitude - thickness} L #{x + width - altitude} #{y + height - altitude} z", fill: color.darken_by(50).html))
    svg << tag(:path, options.merge(d: "M #{x + width - altitude - thickness} #{y + height - altitude - thickness} L #{x - altitude - thickness} #{y + height - altitude - thickness} L #{x - altitude} #{y + height - altitude} L #{x + width - altitude} #{y + height - altitude} z", fill: color.darken_by(70).html))
    unless options[:top].is_a?(FalseClass)
      if thickness > 0
        svg << tag(:rect, width: width, height: height, x: x - thickness, y: y - thickness, fill: color.html, class: 'top')
      else
        svg << tag(:rect, width: width, height: height, x: x, y: y, fill: color.html, class: 'top')
      end
    end
    svg
  end
end
