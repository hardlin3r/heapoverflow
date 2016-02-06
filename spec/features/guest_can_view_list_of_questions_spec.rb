require 'rails_helper'

feature 'User view questions', %q{
In order to view questions
As a Guest
I want to view questions
} do

  given!(:question_list) { create_list(:question, 5) }

  scenario 'Guest tries to view list of questions' do
    visit questions_url
    question_list.each do |q|
      expect(page).to have_content q.title
    end
  end
end

