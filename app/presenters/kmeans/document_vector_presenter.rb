class DocumentVectorPresenter < Presenter
  def as_json(*)
    {
        document: @object.content,
        user_info: @object.user_info
    }
  end
end