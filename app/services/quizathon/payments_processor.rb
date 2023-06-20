module Quizathon

  class PaymentsProcessor

    def initialize(user, quiz)
      @user = user
      @quiz = quiz
    end

    def update_payment
      if @user && (payment = Payment.where(user: @user, quiz_id: @quiz.id).last) && payment.session_id && payment.status != 'paid'
        payment.status = Stripe::Checkout::Session.retrieve(payment.session_id)[:payment_status]
        payment.save
      end
    end

    def user_can_play_quiz?
      if @user && ((QuizRunner.exists?(user_id: @user.id, quiz_id: @quiz.id) || QuizRunner.where(user_id: @user.id).count < Quizathon::FREE_QUIZ_COUNT) || Payment.exists?(user_id: @user.id, quiz_id: @quiz.id, status: 'paid'))
        true
      end
    end

  end

end
