class Centroid

  def initialize
    @grouped_documents = Array.new
  end

  def add_document(document)
    @grouped_documents << document
  end

  def first_document
    @grouped_documents.first
  end

  def first_vector_space
    first_document.vector_space
  end

end