class FeaturedQuizMailer < ApplicationMailer

  default from: Quizathon::MAIL_FROM

  def featured_quiz_email
    @quiz = params[:quiz]
    mail(bcc: params[:emails], subject: 'New quiz will be featured soon!')
  end

end
