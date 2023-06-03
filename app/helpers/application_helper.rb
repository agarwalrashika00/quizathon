module ApplicationHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, object: new_object)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_select_questions(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_selector", f: builder, object: new_object)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def has_completed(user, quiz)
    QuizRunner.find_by(user_id: user.id, quiz_id: quiz.id)&.completed?
  end

  def compute_score(user, quiz)
    QuizRunner.find_by(user_id: user.id, quiz_id: quiz.id)&.score
  end

end
