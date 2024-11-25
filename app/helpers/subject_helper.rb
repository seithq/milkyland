module SubjectHelper
  def subject_category(subject)
    MaterialAsset.model_name.name.eql?(subject.class.to_s) ? subject.category.name : subject.group.category.name
  end
end
