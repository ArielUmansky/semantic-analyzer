class KMeans

  #TODO: I think there is an optimization available: I could add the inverse document frequency of the terms in the set  of terms since that's a metric whose value is the same regardless the document

  NUMBER_OF_CENTROIDS_EXCEPTION = "The service cannot infer the number of centroids for Kmeans algorithm. Please read the documentation and add the required metadata"
  NAME_WEIGHT_HEURISTIC = 200


  def name
    Analyzer::KMEANS
  end

  def execute(input_corpus, metadata)

    set_number_of_centroids(input_corpus, metadata)

    corpus = process_input(input_corpus)

    centroids = initialize_centroids(corpus, @number_of_centroids)

    result_set = initialize_cluster_centroid(centroids.count)

    loop do #Uses loop instead of while as Matz suggested

      previous_cluster_center = centroids

      corpus.document_vector_list.each do |document|
        result_set[find_closest_cluster_center(centroids, document)].grouped_documents << document
      end

      centroids = calculate_mean_points(result_set)

      should_stop = check_stopping_criteria(previous_cluster_center, centroids)

      if !should_stop
        result_set = initialize_cluster_centroid(centroids.count)
      end

      break if should_stop
    end

    result_set

  end


  def initialize_centroids(corpus, number_of_centroids)
    centroids = Array.new

    uniq_random = generate_random_set(corpus.count - 1, number_of_centroids)

    uniq_random.each { |random|
      centroid = Cluster.new
      centroid.add_document(corpus.document_vector_list[random])
      centroids << centroid
    }

    centroids
  end

  def generate_random_set(possible_numbers, set_size)
    (0..possible_numbers).to_a.shuffle.take(set_size)
  end

  def initialize_cluster_centroid(count)
    centroids = Array.new
    count.times do |index|
      centroids[index] = Cluster.new
    end
    centroids
  end

  def calculate_mean_points(clusters)
    new_centroids = Array.new
    clusters.each do |cluster|
      new_centroids << cluster.generate_new_centroid
    end
    new_centroids
  end

  def check_stopping_criteria(previous_clusters, actual_clusters)
    previous_clusters.zip(actual_clusters).all?{ |prev, actual| prev.same_centroid?(actual)}
  end

  def find_closest_cluster_center(centroids, document)
    similarity_measure = Array.new
    centroids.each_with_index do |centroid, index|
      similarity_measure[index] = cosine_similarity(centroid.centroid_vector_space, document.vector_space)
    end
    similarity_measure.index(similarity_measure.max)
  end

  def cosine_similarity(a, b)
    dot_product(a, b) / (magnitude(a) * magnitude(b))
  end

  def dot_product(a, b)
    products = a.zip(b).map{|a, b| a * b}
    products.inject(0) {|s,p| s + p}
  end

  def magnitude(point)
    squares = point.map{|x| x ** 2}
    Math.sqrt(squares.inject(0) {|s, c| s + c})
  end

  def pretty_result_set(result_set)
    result_set.map{|centroid| centroid.grouped_documents.map { |document_vector| document_vector.content } }
  end

  def process_input(input_corpus)
    Corpus.new(input_corpus.map{ |document_hash| document_hash[:document] })
  end

  def set_number_of_centroids(input_corpus, metadata)
    validate_metadata(metadata)
    @number_of_centroids = metadata[:nmb_of_centroids].to_i if metadata.key?(:nmb_of_centroids)
    @number_of_centroids = input_corpus.count / metadata[:cluster_size].to_i if @number_of_centroids.nil?
  end

  def validate_metadata(metadata)
    if metadata.nil? || !metadata.is_a?(Hash) || (!metadata.key?(:nmb_of_centroids) && !metadata.key?(:cluster_size))
      raise KMeans::NUMBER_OF_CENTROIDS_EXCEPTION
    end
  end

end