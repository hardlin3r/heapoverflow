FactoryGirl.define do

  factory :question do
    sequence :title do |n|
      "This is a title of the question number #{n}"
    end
    sequence :body do |n|
      "This is a body of the question number #{n}"
    end
    user
    transient do
      answers_count 5
    end

    factory :question_with_answers, class: "Question" do
      after(:create) do |question|
        create(:answer, question: question)
      end
    end

    factory :question_with_lot_of_answers, class: "Question" do
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end

  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

end
