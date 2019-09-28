class Admin::EventsController < AdminController
  before_action :find_event, only: [:show,:edit,:update,:destroy,:reorder]

  def index
    @events = Event.rank(:row_order).all
  end

  def show
    colors = ['rgba(255,99,132,0.2)',
              'rgba(54,162,235,0.2)',
              'rgba(255,206,86,0.2)',
              'rgba(75,192,192,,0.2)',
              'rgba(153,102,255,0.2)',
              'rgba(255,159,64,0.2)'
    ]

    ticket_names = @event.tickets.map {|t| t.name}
    ticket_counts = @event.tickets.map {|t| t.registrations.count}

    @data1 = {
      labels: ticket_names,
      datasets: [{
        label: "# of Registrations",
        data: ticket_counts,
        backgroundColor: colors,
        borderWidth: 1
      }]
    }
  end

  def new
    @event = Event.new
    @event.tickets.build
    @event.attachments.build
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
    @event.attachments.build if @event.attachments.empty?
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

  def reorder
    @event.row_order_position = params[:position]
    @event.save!

    respond_to do |format|
      format.html {redirect_to admin_events_path}
      format.json {render json: {message: "ok"}}
    end
  end

  protected

  def event_params
    params.require(:event).permit(:name,:logo,:remove_logo,:remove_images,
                                  :description,:friendly_id, :status, :category_id,images: [],
                                 tickets_attributes: [:id,:name,:description,:price,:_destroy],
                                 attachments_attributes: [:id,:attachment,:description,:_destroy])
  end

  def find_event
    @event = Event.find_by_friendly_id(params[:id])
  end

end
