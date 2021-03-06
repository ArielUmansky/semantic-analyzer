require "requests/sugar"

class AnalyzerJob
  include SuckerPunch::Job

  def perform(corpus, algorithm, metadata, url)
    begin
      analyzer = Analyzer.new
      result_set = analyzer.perform(corpus, algorithm, metadata)
      json_result = { result_set: analyzer.presenter_class.new(result_set), algorithm: analyzer.algorithm }
      Requests.post(url, data: json_result.to_json, headers: {"Content-type" => "application/json"} )
    rescue RuntimeError => e
      Requests.post(url, data: { error: e.message }.to_json, headers: {"Content-type" => "application/json"} )
    end
  end
end