class AnalyzerController < ApplicationController


  def perform
    begin
      check_params
      analyzer = Analyzer.new
      result_set = analyzer.perform(params[:body][:corpus], params[:body][:algorithm], params[:body][:metadata])
      render json: { result_set: result_set, algorithm: analyzer.algorithm }
    rescue ActionController::ParameterMissing, RuntimeError
      head :unprocessable_entity
    end
  end

  private

  def check_params
     params.require(:body).require(:corpus)
     params.require(:body).permit(:algorithm, :metadata)
  end

end
