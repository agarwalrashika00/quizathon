class FeaturedQuizMailSchedulerJob < ApplicationJob

  queue_as :default

  def perform(quiz)
    user_emails = User.where.not(id: QuizRunner.where(quiz_id: quiz.id).select(:user_id)).pluck(:email)
    FeaturedQuizMailer.with(emails: user_emails, quiz: quiz).featured_quiz_email.deliver_later if user_emails.present?
  end

end
