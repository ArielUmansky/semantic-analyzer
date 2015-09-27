class DocumentVectorPresenter < Presenter
  def as_json(*)
    {
        document: @object.content
    }
  end
end