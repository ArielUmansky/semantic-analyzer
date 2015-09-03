class Cluster

  def initialize
    @grouped_documents = Array.new
  end

  def grouped_documents
    @grouped_documents
  end

  def add_document(document_vector)
    @grouped_documents << document_vector
  end

  def centroid
    @grouped_documents.first
  end

  def centroid_vector_space
    centroid.vector_space
  end

  def array_of_vector_spaces_by_position
    @grouped_documents.map{ |document_vector| document_vector.vector_space }.transpose
  end

  def update_centroid_vector_space
    centroid.vector_space = array_of_vector_spaces_by_position.map{ |array_element| array_element.sum.to_f / array_element.count}
  end

end