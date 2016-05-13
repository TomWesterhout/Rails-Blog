class ArticlesController < ApplicationController

	before_filter :require_login, except: [:index, :show]

	def require_login
		unless logged_in?
			redirect_to root_path
			return false
		end
	end

	include ArticlesHelper

	def index
		@articles = Article.all
	end

	def show
		@article = Article.find(params[:id])
		@comment = Comment.new
		@comment.article_id = @article.id

		@article.view_counter
		@article.save
	end

	def new
		@article = Article.new
	end

	def create
		@article = Article.new(article_params)
		@article.save

		flash.notice = "Article '#{@article.title}' Created!"

		redirect_to article_path(@article)
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy

		flash.notice = "Article '#{@article.title}' Destroyed!"

		redirect_to articles_path
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
		@article.update(article_params)

		flash.notice = "Article '#{@article.title}' Updated!"

		redirect_to article_path(@article)
	end

	def popular
		@articles = Article.all.order(view_count: :desc).limit(3)
	end

	def feed
		@articles = Article.all
		respond_to do |format|
			format.rss { render :layout => false }
		end
	end

	def archive
		@articles = Article.where("cast(strftime('%m', created_at) as int) = ? AND cast(strftime('%Y', created_at) as int) = ?", params[:month], params[:year])
		if params[:month].to_i > 0 && params[:year].to_i > 0 && @articles.empty?
			flash.notice = "No posts available in this time period."
		end
	end

end
