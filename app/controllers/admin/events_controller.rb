class Admin::EventsController < AdminController
  before_action :find_event, only: [:show,:edit,:update,:destroy]

  def index
    @events = Event.all
  end

  def show
  end

  def new
    @event = Event.new
    @event.tickets.build
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to admin_events_path
    else
      render "new"
    end
  end

  def edit
    @event.tickets.build if @event.tickets.empty?
  end

  def update
    if @event.update(event_params)
      redirect_to admin_events_path
    else
      render "edit"
    end
  end

  def destroy
    @event.destroy

    redirect_to admin_events_path
  end

  def bulk_update
    total = 0
    Array(params[:ids]).each do |event_id|
      event = Event.find(event_id)
      if params[:commit] == I18n.t(:bulk_update)
        event.status = params[:event_status]
        if event.save
          total += 1
        end
        flash[:notice] = "成功更新 #{total} 笔资料"
      elsif params[:commit] == I18n.t(:bulk_delete)
        event.destroy
        total += 1
        flash[:alert] = "已删除 #{total} 笔资料"
      end
    end

    redirect_to admin_events_path

  end

  protected

  def event_params
    params.require(:event).permit(:name, :description,:friendly_id, :status, :category_id,
                                 tickets_attributes: [:id,:name,:description,:price,:_destroy])
  end

  def find_event
    @event = Event.find_by_friendly_id(params[:id])
  end

end
