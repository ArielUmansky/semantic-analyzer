class DocumentVector

  def initialize(document_hash)
    @content = validate_content(document_hash)
    @category = validate_category(document_hash[:category]) if document_hash[:category]
    @keywords = validate_keywords(document_hash[:keywords]) if document_hash[:keywords]
    @user_info = document_hash[:user_info]
  end

  def vector_space=(vector_space)
    @vector_space = vector_space
  end

  def user_info
    @user_info
  end

  def vector_space
    @vector_space
  end

  def content
    @content
  end

  def category
    @category
  end

  def keywords
    @keywords
  end

  def contains_term?(term)
    validate_term(term)
    @content.include?(term)
  end

  def term_frequency(term)
    validate_term(term)
    words = @content.split
    result = words.count(term).fdiv(words.count)
    if name?(term)
      result = result * KMeans::NAME_WEIGHT_HEURISTIC
    end
    result
  end

  def name?(term)
    term.first == term.first.upcase
  end

  def same_vector_space?(other_vector_space)
    @vector_space.count == other_vector_space.vector_space.count &&
        @vector_space.zip(other_vector_space.vector_space).all?{ |a, b| a==b }
  end

  private

    def validate_content(input_hash)
      if input_hash.nil? || !input_hash.is_a?(Hash) || !input_hash[:document]
        raise Analyzer::WRONG_INPUT_EXCEPTION
      end
      input_hash[:document]
    end

    def validate_and_return_string(string)
      unless string.is_a?(String)
        raise Analyzer::WRONG_INPUT_EXCEPTION
      end
      string
    end

    def validate_category(category)
      validate_and_return_string(category)
    end

    def validate_keywords(keywords)
      unless keywords.is_a?(Array) && keywords.all? { |k| k.is_a?(String) }
        raise Analyzer::WRONG_INPUT_EXCEPTION
      end
      keywords
    end

    def validate_term(term)
      validate_and_return_string(term)
    end


end
