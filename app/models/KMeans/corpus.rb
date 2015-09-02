class Corpus

  def initialize(array_of_documents_as_strings)
    validate_documents(array_of_documents_as_strings)
    initialize_document_list(array_of_documents_as_strings)
  end

  def document_vector_list
    @document_vector_list
  end

  def add_to_document_vector_list(document_vector)
    @document_vector_list.add(document_vector)
  end

  def count
    @document_vector_list.count
  end

  def documents
    @document_vector_list.map { |document_vector| document_vector.content }
  end

  private

    def initialize_document_list(array_of_documents_as_strings)
      @document_vector_list = Array.new
      array_of_documents_as_strings.each do |document|
        document_vector = DocumentVector.new(document)
        document_vector.vector_space = calculate_vector_space(document)
        @document_vector_list << document_vector
      end
    end

    def validate_documents(array_of_documents_as_strings)
      if array_of_documents_as_strings.nil? || !array_of_documents_as_strings.is_a?(Array)
        raise Analyzer::WRONG_INPUT_EXCEPTION
      end

      array_of_documents_as_strings.each do |document|
        if !document.is_a?(String) || document.blank?
          raise Analyzer::WRONG_INPUT_EXCEPTION
        end
      end
1   end

    def calculate_vector_space(document_vector)
      #TODO: I have to find out how the vector should be formatted since each document may have different words that don't appear in other, so one position may have a different meaning if the terms are different

      # See the distances paper and think about an algorithm that generates an array whose size be the total amount of different terms in the corpus and each position belongs to a certain term
      # Then, the vector space should contain an array of same proportions in which each position be the tf_idf value of each term for that document
      # STUDY ABOUT TF IDF TO ASSERT THAT THE PREVIOUS NOTE MAKES SENSE (IS TF_IDF A METRIC OF A TERM OR A METRIC FOR THE WHOLE DOCUMENT  ?????????????) - CHECK ALSO K MEANS DOCUMENTATION

    end

    def tf_idf(document_vector, term)
      document_vector.term_frequency(term) * inverse_document_frequency(term)
    end

    def inverse_document_frequency(term)
      Math.log( @documents.count.fdiv(nmb_of_docs_that_contains(term)) )
    end

    def nmb_of_docs_that_contains(term)
      @documents.count { |document| document.split.include?(term)}
    end

end