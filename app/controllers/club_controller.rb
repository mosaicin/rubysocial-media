class ClubController < ApplicationController
  include ClubAccess

  before_action :require_club_member

  def index
    @posts = Post.includes(:topic).order(created_at: :desc).limit(30)
  end
end
