module Quizathon

  class StripePaymentProcessor

    def initialize(success_url, cancel_url, quiz, user)
      @success_url = success_url
      @cancel_url = cancel_url
      @quiz = quiz
      @current_user = user
    end

    def create_stripe_session
      Stripe::Checkout::Session.create({
        success_url: @success_url,
        cancel_url: @cancel_url,
        mode: "payment",
        line_items: [{
          price_data: {
            currency: @quiz.currency_code || Quizathon::CURRENCY_CODE,
            unit_amount: @quiz.amount || Quizathon::QUIZ_AMOUNT,
            product_data: {
              name: @quiz.title,
              description: @quiz.description,
              metadata: {
                userId: @current_user.id,
                productId: @quiz.id
              },
            },
          },
          quantity: 1
        }]
      })
    end

  end

end
