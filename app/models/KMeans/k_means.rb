class KMeans

  def initialize
    @number_of_centroids = 2
  end

  def execute(corpus)

    centroids = initialize_centroids(corpus, @number_of_centroids) #TODO: Retrieve NUMBER_OF_CENTROIDS

    result_set = initialize_cluster_centroid(centroids.count)

    loop do #Uses loop instead of while as Matz suggested

      previous_cluster_center = centroids

      corpus.document_vector_list.each do |document|#TODO
        result_set[find_closest_cluster_center(centroids, document)].grouped_documents << document
      end

      centroids = initialize_cluster_centroid(centroids.count) #TODO: Review this
      centroids = calculate_mean_points(result_set)

      should_stop = check_stopping_criteria(previous_cluster_center, centroids)

      if !should_stop
        result_set = initialize_cluster_centroid(centroids.count)
      end

      break if should_stop
    end

  end


  def initialize_centroids(corpus, number_of_centroids)
    centroids = Array.new

    uniq_random = generate_random_set(corpus.count, number_of_centroids)

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
    clusters.each do |cluster|
      cluster.update_centroid_vector_space
    end
  end

  def check_stopping_criteria(previous_clusters, actual_clusters)
    previous_clusters.zip(actual_clusters).all?{ |prev, actual| prev.same_cluster?(actual)}
  end

  def find_closest_cluster_center(clusters, document)
    similarity_measure = Array.new
    clusters.each_with_index do |cluster, index|
      similarity_measure[index] = cosine_similarity(cluster.centroid_vector_space, document.vector_space)
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

end