# run_classification.rb
require 'weka'
require_relative 'file_loader'
require_relative 'text'

instances = Weka::Core::Instances.from_arff('generated/articles.arff')
instances.class_attribute = :class

classifier = Weka::Classifiers::Trees::RandomForest.new

# The -I option determines the number of decision trees that are used in each
# learning iteration, the default is 100, we increase it to 200 here to gain a
# better performance.
classifier.use_options('-I 200')

classifier.train_with_instances(instances)
evaluation = classifier.cross_validate(folds: 10)
puts evaluation.summary


article_types   = %i(athletics cricket football rugby tennis)

def feature_list_for(article_type)
  files = FileLoader.new('data/test').files_for(article_type)

  files.map do |file|
    # Remember that Text#features returns a Hash.
    # We only need the feature values.
    # Since the class value is still missing, but this time, we append a "missing"
    # as class value. You can use nil, '?' or Float::NAN.
    Text.new(file).features.values << '?'
  end
end

article_types.each do |article_type|
  feature_list = feature_list_for(article_type)

  feature_list.map do |features|
    label = classifier.classify(features)
    puts "* article about #{article_type} classified as #{label}"
  end
end
