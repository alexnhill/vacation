class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
    @trip = Trip.find(params[:trip_id])
    @vote = Vote.new
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
      puts @item.inspect
      puts "⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️"
      vote = @item.votes.create(up_down: 0, user: current_user)
      redirect_to action: "show", id: @item.id
    else
      puts "🔴 🔴  DID NOT SAVE!!! 🔴 🔴 "
      puts @item.inspect
      puts "🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴 🔴"
      @trip = Trip.find_by(id: params[:trip_id])
      # @item = Item.new
      @errors = @item.errors.full_messages
      puts @errors
      puts "🔴 🔴  DID NOT SAVE!!! 🔴 🔴 "
      puts @errors.empty?
      puts "🔴 🔴  DID NOT SAVE!!! 🔴 🔴 "
      puts "🔴 🔴  DID NOT SAVE!!! 🔴 🔴 "
      render '/trips/show'
    end
  end

  def update
    @trip = Trip.find_by(id: params[:trip_id])
    @item = Item.find_by(id: params[:id])
    if @item.update_attributes(item_params)
      redirect_to action: "show", id: @item.id
    else
      render 'edit'
    end
  end

  def edit
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
