class AnalyzerController < ApplicationController

  def perform
    Analyzer.perform(request.body)
  end

end
