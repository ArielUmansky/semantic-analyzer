class Cluster

  def initialize
    @grouped_documents = Array.new
  end

  def grouped_documents
    @grouped_documents
  end

  def add_document(document_vector)
    @grouped_documents << document_vector
    @vector_space_size = document_vector.vector_space.count if @vector_space_size.nil?
  end

  def centroid
    if @grouped_documents
      @grouped_documents.first
    else
      empty_document_vector
    end
  end

  def category
    centroid.category
  end

  def empty_document_vector
    result = DocumentVector.new(DocumentVector::EMPTY_CONTENT)
    result.vector_space = Array.new(@vector_space_size, 0.0)
    result
  end

  def centroid_vector_space
    centroid.vector_space
  end

  def has_documents?
    @grouped_documents.any?
  end

  def array_of_vector_spaces_by_position
    @grouped_documents.map{ |document_vector| document_vector.vector_space }.transpose
  end

  def calculate_mean_vector_space
    array_of_vector_spaces_by_position.map{ |array_element| array_element.sum.to_f / array_element.count}
  end

  def same_centroid?(other_cluster)
    centroid.same_vector_space?(other_cluster.centroid)
  end

  def generate_new_centroid
    new_centroid = Cluster.new
    new_document_vector = DocumentVector.new({document: centroid.content})
    new_document_vector.vector_space = calculate_mean_vector_space
    new_centroid.add_document(new_document_vector)
    new_centroid
  end

end