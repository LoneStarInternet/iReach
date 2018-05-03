unless defined?(AppEnv)
  class AppEnv
   def self.git_commit(cached=true)
     return @git_commit if cached && @git_commit
     `git log | head -n1`.to_s.strip.split(/\s+/).last
   end
   @git_commit = self.git_commit(false)
   
   def self.current_app_path
     File.expand_path('.')
   end
  
   def self.current_release_path
     Pathname.new(File.expand_path("../../current")).readlink.to_s
   end
  end
end
