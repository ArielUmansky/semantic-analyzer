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

  def calculate_mean_vector_space
    array_of_vector_spaces_by_position.map{ |array_element| array_element.sum.to_f / array_element.count}
  end

  def same_centroid?(other_cluster)
    centroid.same_vector_space?(other_cluster.centroid)
  end

  def generate_new_centroid
    new_centroid = Cluster.new
    new_document_vector = DocumentVector.new(centroid.content)
    new_document_vector.vector_space = calculate_mean_vector_space
    new_centroid.add_document(new_document_vector)
    new_centroid
  end

end