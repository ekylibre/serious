module Serious
  TAXES = {
    french_vat_normal_2014: 20,
    french_vat_intermediate_2014: 10,
    french_vat_reduced: 5.5,
    french_vat_null: 0
  }.with_indifferent_access
  # autoload Tenant, 'serious/tenant'
end
