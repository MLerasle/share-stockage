class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:id])
    @articles = @category.articles.order("created_at DESC").page(params[:page]).per(10)
  end
end