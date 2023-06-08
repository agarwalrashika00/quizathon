class QuizRunner < ApplicationRecord

  belongs_to :user
  belongs_to :quiz

  enum status: { started: 0, unrated: 1, completed: 2 }

  validates :user_id, uniqueness: { scope: :quiz_id, message: 'You have already given the quiz' }
  validate :user_pays_after_second_quiz, on: :create

  scope :between, -> (from, to) {
    where(created_at: from..to)
  }

  def find_next_slug(current_question_slug)
    sorting_order_array = questions_sorting_order[1...-1].split(',')
    sorting_order_array[sorting_order_array.find_index(current_question_slug) + 1]
  end

  def find_previous_slug(current_question_slug)
    sorting_order_array = questions_sorting_order[1...-1].split(',')
    unless sorting_order_array.find_index(current_question_slug) == 0
      sorting_order_array[sorting_order_array.find_index(current_question_slug) - 1]
    end
  end

  def marked_option_ids
    UserSolution.where(quiz_question_id: quiz.quiz_question_ids, user_id: user.id).pluck(:marked_option_id)
  end

  def marked_correct_options
    QuestionOption.where(id: marked_option_ids).where(correct: true)
  end

  def compute_total_score
    score = 0
    marked_correct_options.each do |correct_option|
      score += correct_option.question.score
    end
    score
  end

  def complete_quiz
    self.score = compute_total_score
    self.status = 'completed'
    save
  end

  private

  def user_pays_after_second_quiz
    if QuizRunner.where(user_id: user.id).count >= 2
      unless QuizOrder.exists?(user_id: user.id, quiz_id: quiz.id, status: 'paid')
        errors.add :base, 'User cannnot give another quiz without paying first'
      end
    end
  end

end
