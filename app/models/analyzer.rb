class Analyzer

  WRONG_INPUT_EXCEPTION = "Wrong input format. The format must be an array of not-empty strings"

  def perform
    @algorithm.execute(corpus)
  end

end
