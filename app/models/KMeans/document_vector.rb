class DocumentVector

  def initialize(content)
    validate_content(content)
    @content = content
  end

  def vector_space=(vector_space)
    @vector_space = vector_space
  end

  def vector_space
    @vector_space
  end

  def content
    @content
  end

  def contains_term?(term)
    validate_term(term)
    @content.include?(term)
  end

  def term_frequency(term)
    validate_term(term)
    words = @content.split
    words.count(term).fdiv(words.count)
  end

  def same_vector_space?(other_vector_space)
    @vector_space.count == other_vector_space.vector_space.count &&
        @vector_space.zip(other_vector_space.vector_space).all?{ |a, b| a==b }
  end

  private

    def validate_content(content)
      if content.nil? || !content.is_a?(String)
        raise Analyzer::WRONG_INPUT_EXCEPTION
      end
    end

    def validate_term(term)
      validate_content(term)
    end

end
