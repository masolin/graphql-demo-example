class ApiController < ApplicationController

  def graphql
    result = ::RootSchema.execute(params[:query])
    render json: result
  end
end
