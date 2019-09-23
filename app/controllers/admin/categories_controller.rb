class Admin::CategoriesController < AdminController
  before_action :find_category, only: [:show,:edit,:update,:destroy]
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path
    else
      render "new"
    end
  end

  def show
  end

  def edit
  end


  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render "edit"
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by_id(params[:id])
  end
end
