class KeywordsController < ApplicationController
  before_action :set_keyword, only: [:show, :edit, :update, :destroy]

  def index
    @q = Keyword.ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @keywords = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @keyword = Keyword.new
  end

  def edit
  end

  def create
    @keyword = Keyword.new(keyword_params)

    if @keyword.save
      @keyword.create_activity(:create, owner: current_user, parameters: { name: @keyword.name })
      redirect_to keywords_path, notice: 'Keyword was successfully created.'
    else
      render :new
    end
  end

  def update
    if @keyword.update(keyword_params)
      @keyword.create_activity(:update, owner: current_user, parameters: { name: @keyword.name })
      redirect_to keywords_path, notice: 'Keyword was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @keyword.create_activity(:destroy, owner: current_user, parameters: { name: @keyword.name })
    @keyword.destroy
    redirect_to keywords_path, notice: 'Keyword was successfully destroyed.'
  end

  private

  def set_keyword
    @keyword = Keyword.find(params[:id])
  end

  def keyword_params
    params.require(:keyword).permit(:name)
  end
end
