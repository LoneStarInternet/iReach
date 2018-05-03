class StatusController < ActionController::Base
  protect_from_forgery
  def index
    Delayed::Status.ok?(params[:job_seconds].blank? ? 15.minutes : params['job_seconds'].to_i.seconds)
    raise "Not in current working directory! (#{AppEnv.current_app_path} != #{AppEnv.current_release_path})" unless AppEnv.current_release_path == AppEnv.current_app_path
    raise "Newest git commit not loaded! (#{AppEnv.git_commit} != #{AppEnv.git_commit(false)})" unless AppEnv.git_commit == AppEnv.git_commit(false)
    message = 'AppEnv not defined.'
    if defined?(AppEnv)
      message = <<EOT
Latest Release: #{AppEnv.current_release_path}
Application CWD: #{AppEnv.current_app_path}
Loaded Commit: #{AppEnv.git_commit}
Latest Available Commit: #{AppEnv.git_commit(false)}
EOT
    end
    render :text => "OK\n\n#{message}", content_type: 'text/plain'
  rescue Delayed::StatusException=> e
    if File.exists?('tmp/status_error') and File.mtime('tmp/status_error') > 1.hour.ago
      render :text => "#{e.message}\n #{e.backtrace.join("\n ")}", :status => 500
    else
      FileUtils.touch('tmp/status_error')
      raise e
    end
  rescue RuntimeError => e
    render :text => "#{e.message}\n #{e.backtrace.join("\n ")}", :status => 500
  end
  
end

