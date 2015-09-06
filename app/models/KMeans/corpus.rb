class Corpus

  MEANINGLESS_CHARS = ",."

  SPANISH_PREPOSITIONS = ["a", "ante", "bajo", "cabe", "con", "contra", "de", "desde", "en", "entre", "hacia", "hasta",
                          "para", "por", "según", "sin", "so", "sobre", "tras"]

  SPANISH_TRIVIAL_WORDS = ["el", "la", "lo", "los", "las", "este", "ese", "estos", "estas", "esos", "esas", "mi", "tu",
                      "que", "y", "o", "si", "no", "se", "del", "su"]

  def initialize(input_data)
    validate_documents(input_data)
    array_of_strings = input_data #Because the rest has a side effect on the string
    initialize_document_list(array_of_strings)
  end

  def document_vector_list
    @document_vector_list
  end

  def count
    @document_vector_list.count
  end

  def document_vector_contents
    @document_vector_list.map { |document_vector| document_vector.content }
  end

  def documents
    @documents
  end

  private

    def initialize_document_list(input_array_of_strings)

      @documents = input_array_of_strings

      array_of_strings = apply_heuristic_filters(input_array_of_strings)

      @set_of_terms = initialize_set_of_terms(array_of_strings)

      @modified_documents = array_of_strings

      @document_vector_list = Array.new
      array_of_strings.each do |document|
        document_vector = DocumentVector.new(document)
        calculate_vector_space!(document_vector)
        @document_vector_list << document_vector
      end
    end

    def initialize_set_of_terms(array_of_strings)
      Set.new(array_of_strings.map { |d| sieve_document!(d); d.split (' ')}.flatten)
    end

    def validate_documents(array_of_strings)
      if array_of_strings.nil? || !array_of_strings.is_a?(Array)
        raise Analyzer::WRONG_INPUT_EXCEPTION
      end

      array_of_strings.each do |document|
        if !document.is_a?(String) || document.blank?
          raise Analyzer::WRONG_INPUT_EXCEPTION
        end
      end
1   end

    def calculate_vector_space!(document_vector)
      vector_space = Array.new
      @set_of_terms.each_with_index do |term, index|
        vector_space[index] = tf_idf(document_vector, term)
      end
      document_vector.vector_space = vector_space
    end

    def tf_idf(document_vector, term)
      document_vector.term_frequency(term) * inverse_document_frequency(term)
    end

    def inverse_document_frequency(term)
      Math.log( @modified_documents.count.fdiv(nmb_of_docs_that_contains(term)) )
    end

    def nmb_of_docs_that_contains(term)
      @modified_documents.count { |document| document.split.include?(term)}
    end

    def sieve_document!(document)
      document = document.tr((MEANINGLESS_CHARS), "")#.parameterize
    end

    def apply_heuristic_filters(array_of_strings)
      array_of_strings.map { |document| document.split.reject { |term| SPANISH_TRIVIAL_WORDS.include?(term) || SPANISH_PREPOSITIONS.include?(term) }.join(" ") }
    end

end