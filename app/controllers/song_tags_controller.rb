class SongTagsController < ApplicationController
  def create
    authorize :song_tag, :create_and_destroy?
    SongTag.create tag_id: params[:tag_id],
      song_id: params[:song_id],
      church_id: current_user.church_id
  end

  def destroy
    authorize :song_tag, :create_and_destroy?
    SongTag.where(
      tag_id: params[:tag_id],
      song_id: params[:song_id],
      church_id: current_user.church_id
    ).first.destroy
  end
end