require_relative "feature_helper"

feature "delete attachment from question", %q{
As an author of the question
I want to delete attachment to the question
} do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question)}

  describe "Authenticated user" do

   context "deletes attachment from his question" do

     before do
       sign_in(user)
       visit question_path(question)
     end

     scenario "can see the link to remove attachment" do
       within('.attachment'){ expect(page).to have_link("Remove attachment") }
     end

     scenario "can remove attachment", js: true do
       within('.attachment') do
         click_on 'Remove attachment'
       end
       sleep 0.2
       expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
     end
   end

   context "deletes attachment from another users question" do

     before do
       sign_in(another_user)
     end

     scenario "don't see link to remove attachment" do
       expect(page).to_not have_link 'Remove attachment'
     end
   end
  end

  describe "Unauthenticated user" do

    scenario "can't see link to delete attachment" do
      expect(page).to_not have_link 'Remove attachment'
    end
  end
end
