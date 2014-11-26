class DashboardsController < ApplicationController 

  before_filter :admin_only, only: [:index]

  def index
    @dashboards = Dashboard.all
  end

  private
  def admin_only
    unless is_admin?(get_token)
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: {
        error: 'You are not an admin'
        }, status: 403
    end
  end

  def get_token
    token = request.headers.env['HTTP_AUTHORIZATION'].gsub(/Token token=/, "")
  end

  def is_admin?(token)
    User.where(token: token)[0].admin?
  end

end