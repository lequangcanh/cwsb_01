FactoryGirl.define do
  factory :admin do
    email "admin@gmail.com"
    password "password"
    password_confirmation "password"
  end
end
