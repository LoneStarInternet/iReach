class StatusController < ActionController::Base
  def index
    Delayed::Status.ok?(params[:job_seconds].blank? ? 15.minutes : params['job_seconds'].to_i.seconds)
    render :text => 'OK'
  rescue Delayed::StatusException=> e
    if File.exists?('tmp/status_error') and File.mtime('tmp/status_error') > 1.hour.ago
      render :text => "#{e.message}\n #{e.backtrace.join("\n ")}", :status => 500
    else
      FileUtils.touch('tmp/status_error')
      raise e
    end
  end
  
end

