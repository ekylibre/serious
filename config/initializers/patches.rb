class ::Array

  def jsonize_keys
    return map do |v|
      (v.respond_to?(:jsonize_keys) ? v.jsonize_keys : v)
    end
  end

end

class ::Hash

  def jsonize_keys
    return self.deep_transform_keys do |key|
      key.to_s.camelize(:lower)
    end
  end

end
