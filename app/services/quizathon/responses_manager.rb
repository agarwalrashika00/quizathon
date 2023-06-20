module Quizathon

  class ResponsesManager

    def initialize(user, quiz_question)
      @user = user
      @quiz_question = quiz_question
    end

    def submit(marked_option_id)
      if user_solution = UserSolution.find_by(user: @user, quiz_question: @quiz_question)
        user_solution.marked_option_id = marked_option_id
      else
        user_solution = UserSolution.new(user: @user, quiz_question: @quiz_question, marked_option_id: marked_option_id)
      end

      user_solution.save
      user_solution
    end

  end

end
