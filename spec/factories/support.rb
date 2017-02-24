FactoryGirl.define do
  factory :support do
    user
    from_admin true
    content "hello"
    is_read true
  end
end
