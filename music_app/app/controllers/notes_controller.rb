class NotesController < ApplicationController
  before_action :only_note_author!, only: [:destroy]

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    if @note.save
      flash[:notice] = ["Thanks for the new note!"]
      redirect_to track_url(@note.track)
    else
      flash[:errors] = @note.errors.full_messages
      redirect_to track_url(@note.track)
    end
  end

  def destroy
    @note = Note.find(params[:id])
    track = @note.track
    @note.delete
    redirect_to track_url(track)
  end

  def only_note_author!
    @note = Note.find(params[:id])
    render json: "Forbidden", status: :forbidden if @note.user_id != current_user.id
  end

  private

  def note_params
    params.require(:note).permit(:body, :track_id)
  end
end
