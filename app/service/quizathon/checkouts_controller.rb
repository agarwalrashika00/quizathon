module Quizathon

  class CheckoutsController

    def initialize(success_url, cancel_url, quiz, currency, amount, current_user)
      @success_url = success_url
      @cancel_url = cancel_url
      @quiz = quiz
      @currency = currency
      @amount = amount
      @current_user = current_user
    end

    def create_stripe_session
      Stripe::Checkout::Session.create({
        success_url: @success_url,
        cancel_url: @cancel_url,
        mode: "payment",
        line_items: [{
          price_data: {
            currency: @currency,
            unit_amount: @amount,
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
