require 'require_all'

require_all "app/models/"

class Analyzer

  WRONG_INPUT_EXCEPTION = "Wrong input format. The format must be an array of not-empty strings"
  UNSUPPORTED_ALGORITHM_EXCEPTION = "The specified algorithm is not supported"
  KMEANS = "kmeans"

  def perform(corpus, algorithm, metadata)
    set_algorithm(algorithm)
    @algorithm.execute(corpus, metadata)
  end

  def algorithm
    @algorithm.name
  end

  def set_algorithm(algorithm)
    if algorithm.nil?
      @algorithm = self.default_algorithm
    elsif algorithm == KMEANS
      @algorithm = KMeans.new
    else
      raise Analyzer::UNSUPPORTED_ALGORITHM_EXCEPTION
    end
  end

  def default_algorithm
    KMeans.new
  end

end
