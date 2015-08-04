require 'serious/tenant'

# Directory of ekylibre is assumed to be at same level of Serious
# by default. This value can be overriden but the ekylibre app must
# in same filesystem.
Serious::Tenant.ekylibre_path = Rails.root.dirname.join('ekylibre')
