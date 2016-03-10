class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :admin_authorization, except: [:index, :show]
  before_filter :find_article, except: [:index, :new, :create]
  
  def index
    @articles = Article.order("created_at DESC").page(params[:page]).per(10)
  end

  def show
  end

  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to articles_path
    else
      render action: :new
    end
  end
  
  def edit
  end
  
  def update
    if @article.update_attributes(article_params)
      redirect_to articles_path
    else
      render action: :edit
    end
  end
  
  def destroy
    @article.destroy if current_user and current_user.admin?
    redirect_to articles_path
  end
  
  private

  def find_article
    @article = Article.friendly.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :category_ids => [])
  end

  def admin_authorization
    return redirect_to articles_path unless current_user.admin? or current_user.email == "b.berlier@gmail.com"
  end
end