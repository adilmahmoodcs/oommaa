class KeywordsController < ApplicationController
  before_action :set_keyword, only: [:show, :edit, :update, :destroy]

  def index
    authorize Keyword
    @q = policy_scope(Keyword).ransack(params[:q])
    @q.sorts = "name_case_insensitive asc" if @q.sorts.empty?
    @keywords = @q.result.page(params[:page])
  end

  def show
    authorize @keyword
  end

  def new
    authorize Keyword
    @keyword = Keyword.new
  end

  def edit
    authorize @keyword
  end

  def create
    authorize Keyword
    @keyword = Keyword.new(keyword_params)

    if @keyword.save
      @keyword.create_activity(:create, owner: current_user, parameters: { name: @keyword.name })
      redirect_to keywords_path, notice: 'Keyword was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @keyword
    if @keyword.update(keyword_params)
      @keyword.create_activity(:update, owner: current_user, parameters: { name: @keyword.name })
      redirect_to keywords_path, notice: 'Keyword was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @keyword
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
