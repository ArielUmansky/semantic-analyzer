class AnalyzerController < ApplicationController


  def perform
    begin
      check_params
      analyzer = Analyzer.new
      result_set = analyzer.perform(params[:body][:corpus], params[:body][:algorithm], params[:body][:metadata])
      render json: { result_set: analyzer.presenter_class.new(result_set), algorithm: analyzer.algorithm }
    rescue ActionController::ParameterMissing, RuntimeError
      head :unprocessable_entity
    end
  end

  private

  def check_params
     params.require(:body).require(:corpus).each do |document_input|
       if document_input.respond_to?(:require)
         document_input.require(:document)
         document_input.permit(:category, :keywords, :user_info)
       else
         raise ActionController::ParameterMissing.new("")
       end
     end

     params.require(:body).permit(:algorithm, :metadata)
  end

end
