class InsuranceIndemnification < ActiveRecord::Base
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_date :paid_on, allow_blank: true, on_or_after: Date.civil(1, 1, 1)
  validates_numericality_of :montant, allow_nil: true
  validates_presence_of :montant, :paid_on
  #]VALIDATORS]
end
