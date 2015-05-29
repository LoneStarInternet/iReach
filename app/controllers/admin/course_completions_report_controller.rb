class Admin::CourseCompletionsReportController < ApplicationController
  def index
    @course_completion_counts = CourseCompletion.joins(:course).group(:number).count
    @course_completion_last_completions = CourseCompletion.joins(:course).
      select("number, MAX(completed_at) max_completed_at").group(:number).inject({}) do |hash,completion|
        hash.merge!(completion[:number] => completion[:max_completed_at])
    end
    @courses = []
    Struct.new("Completion", :name, :number, :last_completed_on, :total_completions) unless defined?(Struct::Completion)
    Course.all.each do |course|
      @courses << Struct::Completion.new(course.name, course.number, 
        @course_completion_last_completions[course.number],
        @course_completion_counts[course.number]
      )
    end
    @courses = @courses.sort_by{|a| [a.total_completions.to_i, a.last_completed_on]}.reverse
  end

  def conventions
    @convention = Convention.find(params[:id])
    @members = Member.order("last_name, first_name").paginate(page: params[:page], per_page: 100)
  end

  def members
    @members = Member.order("last_name, first_name").paginate(page: params[:page], per_page: 100)
  end
end