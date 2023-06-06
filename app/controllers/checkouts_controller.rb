class CheckoutsController < ApplicationController

  def create
    quiz = Quiz.find_by_slug(params[:slug])

    session = Stripe::Checkout::Session.create({
      success_url: quiz_url(quiz, success: true),
      cancel_url: quiz_url(quiz),
      mode: "payment",
      line_items: [{
        price_data: {
          currency: "inr",
          unit_amount: 500,
          product_data: {
            name: quiz.title,
            description: quiz.description,
            metadata: {
              userId: current_user.id,
              productId: quiz.id
            },
          },
        },
        quantity: 1
      }]
    })

    quiz_order = QuizOrder.new(session_id: session.id, quiz_id: quiz.id, user_id: current_user.id, status: session[:payment_status])

    if quiz_order.save
      redirect_to session.url, allow_other_host: true
    else
      redirect_to quiz_path(quiz), notice: quiz_order.errors.to_a
    end

  end

end
