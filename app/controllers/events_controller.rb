class EventsController < ApplicationController

  def index
    #@events = Event.rank(:row_order).all
    @events = Event.only_public.rank(:row_order).all
  end

  def show
    #@event = Event.find_by_friendly_id(params[:id])
    @event = Event.only_available.find_by_friendly_id(params[:id])
  end

end
