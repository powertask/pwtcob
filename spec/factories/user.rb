FactoryGirl.define do 
  factory :user1, class: User do
    id 1
    email "marcelo@powertask.com.br"
    password "12345678"
    profile 0
  end
end
