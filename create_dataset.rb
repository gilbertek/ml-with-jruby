# create_dataset.rb
require 'weka'
require_relative 'feature_extractor'
require_relative 'file_loader'
require_relative 'text'

article_types   = %i(athletics cricket football rugby tennis)
attribute_names = FeatureExtractor.new('').features.keys

dataset = Weka::Core::Instances.new.with_attributes do
  attribute_names.each { |name| numeric(name) }

  nominal(:class, values: article_types, class_attribute: true)
end

def feature_list_for(article_type)
  files = FileLoader.new('data/training').files_for(article_type)

  files.map do |file|
    # Remember that Text#features returns a Hash.
    # We only need the feature values.
    # Since the class value is still missing, we append the
    # article_type as the class value.
    Text.new(file).features.values << article_type
  end
end

article_types.each do |article_type|
  feature_list = feature_list_for(article_type)
  dataset.add_instances(feature_list)
  dataset.to_arff('generated/articles.arff')
end
