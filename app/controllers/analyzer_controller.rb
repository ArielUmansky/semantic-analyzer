class AnalyzerController < ApplicationController

  def perform
    begin
      check_params
      AnalyzerJob.new.async.perform(params[:corpus], params[:algorithm], params[:metadata], params[:url])
      render json: { info: "Acknowledged message. The result will be posted at #{params[:url]}" }, status: 200
    rescue ActionController::ParameterMissing, RuntimeError => e
      render json: { error: e.message }, status: 422
    end
  end

  def status_info
    render json: { status_info: "Aldana linda"}
  end

  private

  def check_params
     params.require(:corpus).each do |document_input|
       if document_input.respond_to?(:require)
         document_input.require(:document)
         document_input.permit(:category, :keywords, :user_info)
       else
         raise ActionController::ParameterMissing.new("")
       end
     end

     params.permit(:algorithm, :metadata, :url)
  end

end
