require_relative 'feature_helper'

feature 'Guest can view question and answers to it', %q{
  As a Guest
  I want to view question and answers to it
} do

  given!(:question_with_lot_of_answers) { create(:question_with_lot_of_answers) }

  scenario 'Guest tries to view question and answers to it' do
    visit question_url(question_with_lot_of_answers)
    expect(page).to have_content question_with_lot_of_answers.body
    expect(page).to have_content question_with_lot_of_answers.title
    question_with_lot_of_answers.answers.each do |answer|
      expect(page).to have_content answer.body
    end

 end

end
