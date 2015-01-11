class AlbumsController < ApplicationController
  before_action :no_logged_out_user!

  def show
    @album = Album.find(params[:id])
    @tracks = @album.tracks
    @band = @album.band
  end

  def new
    @band = Band.find(params[:band_id])
    @bands = Band.all
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)
    @band = @album.band
    @bands = Band.all
    @tracks = @album.tracks
    # @band = Band.find(params[:band_id])
    # @album.band_id = @band.id
    if @album.save
      flash[:notice] = ["Thanks for adding a new album!"]
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @band = @album.band
    @album.destroy
    flash[:notice] = ["Album deleted."]
    redirect_to band_url(@band)
  end

  def edit
    @album = Album.find(params[:id])
    @band = @album.band
    #@band = Band.find(params[:band_id].to_i)
    @bands = Band.all
  end

  def update
    @album = Album.find(params[:id])
    if @album.update(album_params)
      flash[:notice] = "Album updated."
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  private

  def album_params
    params.require(:album).permit(:name, :recording_type, :band_id)
  end
end
