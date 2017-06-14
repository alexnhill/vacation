class ItemsController < ApplicationController
  def show
        puts "⭐️⭐️⭐️⭐️⭐️ ITEMS SHOW CONTROLLER"
    @item = Item.find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @vote = Vote.new
    if @item.date
      @day = @item.date.strftime("%A, %B %e")
    else
      @day = 'TBD'
    end
    @days = []
    @trip.start_date.upto@trip.end_date do |day|
      @days.push(day.strftime("%A, %B %e"))
    end
    @days.push('TBD')
  end

  def new
    @user = User.first
    @trip = Trip.find_by(id: params[:trip_id])
    @item = Item.new
  end

  def create
    @trip = Trip.find_by(id: params[:trip_id])
    @item = current_user.items.new(item_params)
    @item.trip = @trip

    if @item.save
      puts "⭐️⭐️⭐️⭐️⭐️  ITEM WAS SAVED ⭐️⭐️⭐️⭐️⭐️⭐️"
      vote = @item.votes.create(up_down: 0, user: current_user)
      redirect_to action: "show", id: @item.id
    else
      puts "🔴 🔴  DID NOT SAVE!!! 🔴 🔴 "
      @trip = Trip.find_by(id: params[:trip_id])
      @errors = @item.errors.full_messages
      render '/trips/show'
    end
  end

## NEEDS CLEANED UP REALLY BAD!!!
  def update
    @trip = Trip.find_by(id: params[:trip_id])
    @item = Item.find_by(id: params[:id])
    input = params[:item][:date]
    if input == 'Morning'
      hour = 8
      @item.date = @item.date.change(hour: hour)
      @item.save
      redirect_to action: "show", id: @item.id
    elsif input == "Afternoon"
      hour = 14
      @item.date = @item.date.change(hour: hour)
      @item.save
      redirect_to action: "show", id: @item.id
    elsif input == "Night"
      hour = 20
      @item.date = @item.date.change(hour: hour)
      @item.save
      redirect_to action: "show", id: @item.id
    elsif @item.update_attributes(item_params)
      redirect_to action: "show", id: @item.id
    else
      render 'edit'
    end
  end

  def edit
    puts "😈 EDIT 😈 "
    @trip = Trip.find_by(id: params[:trip_id])
    @item = Item.find_by(id: params[:id])
  end

  def destroy
    @trip = Trip.find_by(id: params[:trip_id])
    @item = Item.find_by(id: params[:id])
    @item.destroy
    redirect_to @trip
  end

  private
    def item_params
      params.require(:item).permit(:title, :body, :address, :image, :date, :lookup, :category, :user, :trip)
    end
end
