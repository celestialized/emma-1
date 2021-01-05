class Blog::EntriesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :new, :edit, :update, :destroy]
  before_action :set_blog_entry, only: [:show, :edit, :update, :destroy]

  # GET /blog/entries
  # GET /blog/entries.json
  def index
    @blog_entries = Blog::Entry.all
  end

  # GET /blog/entries/1
  # GET /blog/entries/1.json
  def show
    render :layout => 'frontdoor'

    @blog_entries         = Blog::Entry.all
    @blog_article         = @blog_entry.article
    @recommended_entries  = @blog_entry.recommended_entries    
    @author               = @blog_article.user if @blog_article.present?

  
  end

  # GET /blog/entries/new
  def new
    @blog_entry = Blog::Entry.new
    @articles   = Blog::Article.all.select(:id, :title)
    @blog_entry.recommendations.new
    
  end

  # GET /blog/entries/1/edit
  def edit
    @articles   = Blog::Article.all.select(:id, :title)  
  end

  # POST /blog/entries
  # POST /blog/entries.json
  def create
    @blog_entry = Blog::Entry.new(blog_entry_params)
    # @blog_entry.user = current_user

    respond_to do |format|
      if @blog_entry.save
        # @blog_article = Blog::Article.find(params[:blog_article][:id])
        # @blog_entry.blog_entry_assignments.create!(blog_article: @blog_article)
        format.html { redirect_to @blog_entry, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @blog_entry }
      else
        format.html { render :new }
        format.json { render json: @blog_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blog/entries/1
  # PATCH/PUT /blog/entries/1.json
  def update
    respond_to do |format|
      if @blog_entry.update(blog_entry_params)
        format.html { redirect_to @blog_entry, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog_entry }
      else
        format.html { render :edit }
        format.json { render json: @blog_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blog/entries/1
  # DELETE /blog/entries/1.json
  def destroy
    @blog_entry.destroy
    respond_to do |format|
      format.html { redirect_to blog_entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_entry
      @blog_entry = Blog::Entry.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_entry_params
      params.require(:blog_entry).permit(:title, :image, 
        :pinned_value, 
        :publish_at,
        :article_id, 
        :tag_list
      )
    end
end
