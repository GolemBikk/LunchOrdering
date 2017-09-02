class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :photo

  def photo
    object.photo.small.url
  end
end
