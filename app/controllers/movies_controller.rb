class MoviesController < ApplicationController

  def show
    @movieEntry = Movie.find_by_year(params[:year])
  end

end
