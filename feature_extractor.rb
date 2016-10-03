# feature_extractor.rb
require 'scalpel'

class FeatureExtractor
  attr_reader :text, :paragraphs, :sentences, :words

  def initialize(text)
    @text       = text
    @paragraphs = text.split(/\n{2,}/)
    @sentences  = Scalpel.cut(text)
    @words      = text.scan(/[\w'-]+/)
  end

  def features
    {
      athletics_hints_count:      match_count('athlet'),
      cricket_hints_count:        match_count('cricket'),
      football_hints_count:       match_count('football'),
      rugby_hints_count:          match_count('rugby'),
      tennis_hints_count:         match_count('tennis'),
      capitalized_words_count:    capitalized_words_count,
      gender_dominance:           gender_dominance,
      text_length:                text.length,
      sentences_count:            sentences.count,
      paragraphs_count:           paragraphs.count,
      words_per_sentence_average: words_per_sentence_average,
      quote_count:                quote_count,
      single_sport_hints_count:   terms_count(%w(I me my)),
      team_sport_hints_count:     terms_count(%w(we us our team)),
      number_count:               number_count
    }
  end

  private

  def match_count(word)
    text.scan(/#{word}/i).count
  end

  def capitalized_words_count
    words.count { |w| w.start_with?(w[0].upcase) }
  end

  def gender_dominance
    terms_count(%w(she her)) > terms_count(%w(he his)) ? 1 : 0
  end

  def terms_count(terms)
    words.count { |w| terms.include?(w.downcase) }
  end

  def words_per_sentence_average
    sentences.count.zero? ? 0 : (words.count / sentences.count)
  end

  def quote_count
    text.scan(/"[^"]+"/).count
  end

  def number_count
    text.scan(/\d+[\.,]\d+|\d+/).count
  end
end
