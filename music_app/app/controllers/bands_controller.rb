class BandsController < ApplicationController
  before_action :no_logged_out_user!

  def index
    @bands = Band.all
  end

  def show
    @band = Band.find(params[:id])
    @albums = @band.albums #see note below
    #so maybe... it's allowed to run queries from views if they're associations?
  end

  def new
    @band = Band.new
  end

  def create
    @band = Band.new(band_params)
    if @band.save
      #render :show i think there's a good reason not to do it this way
      #yes it's that the url won't look right, it'll still be the create url rather than the url of the thing you're really at, which will suck if you're trying to share it with someone else
      flash[:notice] = ["Thanks for adding a new band!"]
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :new
    end
  end

  def destroy
    @band = Band.find(params[:id])
    @band.destroy
    flash[:notice] = ["Band deleted."]
    redirect_to bands_url
  end

  def edit
    @band = Band.find(params[:id])
  end

  def update
    @band = Band.find(params[:id])
    if @band.update(band_params)
      flash[:notice] = ["Band updated."]
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :edit
    end
  end

  private

  def band_params
    params.require(:band).permit(:name)
  end
end
