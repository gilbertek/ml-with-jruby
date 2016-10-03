# text.rb
require_relative 'feature_extractor'

class Text
  attr_reader :text
  def initialize(file)
    file_path = File.expand_path(file, __FILE__)

    # There seem to be some invalid UTF-8 characters in the texts,
    # so we remove them here.
    @text = File.read(file_path).encode!('UTF-8', 'UTF-8', invalid: :replace)
  end

  def features
    FeatureExtractor.new(text).features
  end
end
