FactoryGirl.define do
  factory :comment do
    body "MyText"
    user
    association :commentable, factory: answer
  end
end
