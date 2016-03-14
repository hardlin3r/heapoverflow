json.extract! @answer, :id
json.rating @answer.votes.rating
json.authenticated !current_user.nil?
json.author_of current_user.author_of?(@answer)
json.author_of_question current_user.author_of?(@question)
json.voted_for current_user.voted_for?(@answer)
json.unvote_url unvote_question_answer_url(@question, @answer)
json.upvote_url upvote_question_answer_url(@question, @answer)
json.downvote_url downvote_question_answer_url(@question, @answer)
json.best @answer.best
json.set_best_url set_best_question_answer_url(@question, @answer)
