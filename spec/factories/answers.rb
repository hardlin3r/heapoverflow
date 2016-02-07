FactoryGirl.define do
  sequence :body do |n|
    "This is my super answer#{n} to all of the questions possible"
  end

  factory :answer do
    body
    question
    user
    best false
  end

  factory :invalid_answer do
    body nil
    question_id nil
  end

end
