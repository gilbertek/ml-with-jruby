# file_loader.rb
class FileLoader
  attr_reader :data_directoy

  def initialize(directory)
    @data_directoy = File.expand_path("../#{directory}", __FILE__)
  end

  def files_for(article_type)
    Dir.glob("#{data_directoy}/#{article_type}/*.txt")
  end
end
