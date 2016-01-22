FactoryGirl.define do
  factory :answer do
    body "This is my super answer to all of the questions possible"
    question
  end

  factory :invalid_answer do
    body nil
    question_id nil
  end
end
