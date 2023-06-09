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

  def link_to_add_comment(name, quiz, parent_comment)
    comment = Comment.new
    fields = form_with model: comment, url: comment_quiz_path(quiz) do |form|
      render('child_comment', form: form, parent_comment_id: parent_comment.id)
    end
    link_to(name, '#', class: "add_fields", data: {id: comment.object_id, fields: fields.gsub("\n", "") })
  end

end
