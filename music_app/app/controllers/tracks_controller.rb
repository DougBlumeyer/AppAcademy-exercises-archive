class TracksController < ApplicationController
  before_action :no_logged_out_user!

  def show
    @track = Track.find(params[:id])
    @album = @track.album
  end

  def new
    @track = Track.new
    @albums = Album.all
    @album = Album.find(params[:album_id])
  end

  def create
    @track = Track.new(track_params)
    @album = @track.album
    if @track.save
      flash[:notice] = ["Thanks for adding a new track!"]
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def destroy
    @track = Track.find(params[:id])
    @album = @track.album
    @track.destroy
    flash[:notices] = ["Track deleted."]
    redirect_to album_url(@album)
  end

  def edit
    @track = Track.find(params[:id])
    @albums = Album.all
    @album = @track.album
  end

  def update
    @track = Track.find(params[:id])
    if @track.update(track_params)
      flash[:notice] = ["Track updated."]
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end

  private

  def track_params
    params.require(:track).permit(:name, :category, :lyrics, :album_id)
  end
end
