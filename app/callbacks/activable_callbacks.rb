class ActivableCallbacks

  def self.before_validation(model_object)
    if model_object.active_was && !model_object.active && model_object.started_quiz_runners.present?
      model_object.errors.add :active, 'Can\'t inactivate when a user is playing the quiz'
    end
  end

  def self.before_save(model_object)
    if model_object.active? && !model_object.publishable?
      self.active = false
    end
  end

end
