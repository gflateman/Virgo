module Virgo
  class Admin::ColumnsController < Admin::BaseController
    before_action :set_column, only: [:show, :edit, :update, :destroy]

    handles_sortable_columns

    def index
      if params[:sort].nil?
        flash.keep
        redirect_to admin_columns_path(sort: 'weight') and return
      end

      @columns = Column.order(sort_order).with_post_count.page(params[:page])
    end

    def new
      @column = Column.new
    end

    def create
      @column = Column.new(column_params)

      authorize! :create, @column

      if @column.save
        flash[:notice] = "Column created"
        redirect_to admin_columns_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @column.update(column_params)
        flash[:notice] = "Column settings updated"
        redirect_to admin_columns_path
      else
        render :edit
      end
    end

    def destroy
      @column.destroy

      flash[:notice] = "Column removed"

      redirect_to admin_columns_path
    end

    private

    def set_column
      @column = Column.friendly.find(params[:id])

      authorize! :manage, @column
    end

    def column_params
      params.permit(column: [:name, :description, :weight, :image, :slug])[:column]
    end
  end
end
