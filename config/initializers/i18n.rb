class ::Symbol
  def tl(*args)
    ::I18n.t("labels.#{self}", *args)
  end

  def ta(*args)
    ::I18n.t("rest.actions.#{self}", *args)
  end

end

class ::String
  def tl(*args)
    ::I18n.t("labels.#{self}", *args)
  end

  def ta(*args)
    ::I18n.t("rest.actions.#{self}", *args)
  end
end
