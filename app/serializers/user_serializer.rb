class UserSerializer < ActiveModel::Serializer
  attributes :id, :authentication_token, :name, :email
end
