FactoryGirl.define do
  factory :question do
    title "MyStringfdsfdsfsdf"
    body "MyTextfdsaffdsafasf"
    factory :question_with_answers do
      after(:create) do |q|
        create(:answer, question: q)
      end
    end
  end
  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
