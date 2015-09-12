class Corpus

  MEANINGLESS_CHARS = ",."

  SPANISH_PREPOSITIONS = ["a", "ante", "bajo", "cabe", "con", "contra", "de", "desde", "en", "entre", "hacia", "hasta",
                          "para", "por", "según", "sin", "so", "sobre", "tras"]

  SPANISH_TRIVIAL_WORDS = ["el", "la", "lo", "los", "las", "este", "ese", "estos", "estas", "esos", "esas", "mi", "tu",
                      "que", "y", "o", "si", "no", "se", "del", "su"]

  def initialize(input_data)
    validate_documents(input_data)
    initialize_document_list(input_data)
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

    def initialize_document_list(input_array_of_documents)

      @documents = input_array_of_documents.map{ |document_hash| document_hash[:document] }

      @modified_documents_hashes = apply_heuristic_filters!(input_array_of_documents)

      @modified_documents = @modified_documents_hashes.map{ |document_hash| document_hash[:document] }

      @set_of_terms = initialize_set_of_terms(@modified_documents)

      @document_vector_list = Array.new
      @modified_documents_hashes.each do |document_hash|
        document_vector = DocumentVector.new(document_hash)
        calculate_vector_space!(document_vector)
        @document_vector_list << document_vector
      end
    end

    def initialize_set_of_terms(array_of_strings)
      Set.new(array_of_strings.map { |d| d.split (' ')}.flatten)
    end

    def validate_documents(array_of_hashes)
      if array_of_hashes.nil? || !array_of_hashes.is_a?(Array)
        raise Analyzer::WRONG_INPUT_EXCEPTION
      end

      array_of_hashes.each do |document|
        if !document.is_a?(Hash)
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

    def sieve_document(document)
      document.tr((MEANINGLESS_CHARS), "")
    end

    def apply_heuristic_filters!(array_of_hashes)
      new_array = Array.new
      array_of_hashes.each do |document_hash|
        new_hash = Hash.new
        new_hash[:document] = sieve_document(document_hash[:document])
        new_hash[:document] = new_hash[:document].split.reject { |term| SPANISH_TRIVIAL_WORDS.include?(term) || SPANISH_PREPOSITIONS.include?(term) }.join(" ")
        new_hash[:category] = document_hash[:category]
        new_hash[:keywords] = document_hash[:keywords]
        new_array << new_hash
      end
      new_array
    end

end