class ClusterPresenter < Presenter
  def as_json(*)
    {
        grouped_documents: @object.grouped_documents.map { |document_vector| DocumentVectorPresenter.new(document_vector)}
    }
  end
end