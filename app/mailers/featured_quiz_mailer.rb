class FeaturedQuizMailer < ApplicationMailer

  default from: 'featured@example.com'

  def featured_quiz_email
    @quiz = params[:quiz]
    mail(bcc: params[:emails], subject: 'New quiz will be featured soon!')
  end

end
