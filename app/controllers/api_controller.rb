class ApiController < ApplicationController

  def graphql
    result = ::RootSchema.execute(params[:query], max_depth: 2, max_complexity: 2)
    render json: result
  end
end
