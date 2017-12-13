class EventsController < ApplicationController
  def new
  end

  def index
  	@current_user = current_user
  	@events_sameState = Event.where(state:@current_user.state)
  	@events_otherState = Event.where('state != ?',@current_user.state)
  end

  def create
  	event = Event.new(event_params)
  	event.user = current_user
  	if event.valid?
  		event.save
  	else
  		flash[:failed] = event.errors.full_messages
  	end
  	return redirect_to eventsIndex_path
  end

  def show
  	@event = Event.find(params[:event_id])
  	@comments = Comment.where(event:Event.find(params[:event_id]))
  	if !@comments
  		@comments = []
  	end
  	puts @comments
  end

  def update
  	@event = Event.find(params[:event_id])
  	@event.name = params.require(:event).permit(:name)[:name]
  	@event.date = params.require(:event).permit(:date)[:date]
  	@event.location = params.require(:event).permit(:location)[:location]
  	@event.state = params.require(:event).permit(:state)[:state]

  	if @event.valid?
  		@event.save
  		return redirect_to eventsIndex_path params[:event_id]
  	end
  	flash[:failed] = @event.errors.full_messages
  	return redirect_to eventsEdit_path 

  end

  def edit
  	@event = Event.find(params[:event_id])
  end

  def destroy
  	event = Event.delete(Event.find(params[:event_id]))
  	return redirect_to eventsIndex_path
  end

  def join
  	Attendee.create(user:current_user, event:Event.find(params[:event_id]))
  	return redirect_to eventsIndex_path
  end

  def cancel
  	Attendee.delete(Attendee.where(user:current_user, event:Event.find(params[:event_id])))
  	return redirect_to eventsIndex_path
  end

  private
  	def event_params
  		params.require(:event).permit(:name, :date, :location, :state)
 	end
end
