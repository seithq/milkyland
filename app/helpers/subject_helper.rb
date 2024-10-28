module SubjectHelper
  def subject_category(subject)
    Product.model_name.name.eql?(subject.class.to_s) ? subject.group.category.name : subject.category.name
  end
end
