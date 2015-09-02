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
        result_set[find_closest_cluster_center(centroids, document)].grouped_documents.add(document)
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

  private

    def initialize_centroids(corpus, number_of_centroids)
      centroids = Array.new

      uniq_random = generate_random_set(corpus.count, number_of_centroids)

      uniq_random.each { |random|
        centroid = Centroid.new
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
        centroids[index] = Centroid.new
      end
      centroids
    end

    def calculate_mean_points(clusters)
      clusters.each do |cluster|
        cluster.grouped_documents[0].vector_space = cluster.grouped_documents[0].vector_space.avg #TODO: Check this
      end
    end

    def check_stopping_criteria(previous_clusters, actual_clusters)

      #FIXME: Check this with other guy
      #FIXME: Make a refactor. Tell don't ask

      previous_clusters.each do |previous_cluster, cluster_index|
        unless previous_cluster[cluster_index].grouped_documents.map{ |dv| actual_clusters[cluster_index].grouped_documents.include?(dv)}.all?
          return false
        end
      end

      true
    end

    def find_closest_cluster_center(centroids, document)
      similarity_measure = Array.new
      centroids.each_with_index do |centroid, index|
        similarity_measure[index] = cosine_similarity(centroid.first_vector_space, document.vector_space)
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