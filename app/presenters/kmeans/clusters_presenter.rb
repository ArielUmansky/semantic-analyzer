class ClustersPresenter < Presenter
  def as_json(*)
    {
        result: @object.map { |cluster| ClusterPresenter.new(cluster)  }
    }
  end
end