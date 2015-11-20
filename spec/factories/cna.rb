FactoryGirl.define do 
  factory :cna_1, class: Cna do
    id 1
    unit_id 1
    year 2010
    taxpayer_id 1
    nr_document 1234567890
    amount 134.09
    stage 0
    status 0
    start_at Time.now
    due_at 3.months.ago
    fl_charge false
  end
end
