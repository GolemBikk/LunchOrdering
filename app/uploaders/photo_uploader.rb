class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('assets/' + [version_name, 'default.png'].compact.join('_'))
  end

  process resize_to_fill: [300, 200]

  version :small do
    process resize_to_fit: [100, 100]
  end
end
