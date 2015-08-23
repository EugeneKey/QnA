class SearchController < ApplicationController
  authorize_resource

  def index
    @result = Search.search(params[:query], params[:type], params[:page])
    respond_with @result
  end
end
