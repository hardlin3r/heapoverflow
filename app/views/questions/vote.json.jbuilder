json.extract! @question, :id
json.rating @question.votes.rating
json.authenticated !current_user.nil?
json.author_of_question current_user.author_of?(@question)
json.voted_for current_user.voted_for?(@question)
json.unvote_url unvote_question_url(@question)
json.upvote_url upvote_question_url(@question)
json.downvote_url downvote_question_url(@question)
