class StatusController < ActionController::Base
  # skip_before_filter :authenticate

  def index
    AdminUser.first
    Member.first
    Delayed::Status.ok?(params[:job_seconds].blank? ? 15.minutes : params['job_seconds'].to_i.seconds)
    render :text => 'OK'
  rescue => e
    render :text => "#{e.message}\n #{e.backtrace.join("\n ")}", :status => 500
  end

  def raise_error
    raise Exception.new(params[:error])
  end
  
end

