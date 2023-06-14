module Quizathon

  class CheckPaymentsController

    def initialize(user, quiz)
      @user = user
      @quiz = quiz
    end

    def update_quiz_order
      if @user && (quiz_order = QuizOrder.where(user: @user, quiz_id: @quiz.id).last) && quiz_order.status != 'paid'
        quiz_order.status = Stripe::Checkout::Session.retrieve(quiz_order.session_id)[:payment_status]
        quiz_order.save
      end
    end

    def user_can_play_quiz
      if @user && ((QuizRunner.where(user_id: @user.id).count < 2) || QuizOrder.exists?(user_id: @user.id, quiz_id: @quiz.id, status: 'paid'))
        true
      end
    end

  end

end
