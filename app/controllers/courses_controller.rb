class CoursesController < ApplicationController
  before_filter :authorize_courses, only: [:complete]
  before_filter :find_course, only: [:show, :complete]
  skip_before_filter :verify_authenticity_token, only: [:complete]
  layout 'courses'

  def show
  end

  def index
    @one_hour_courses = Course.where(ce_hours: 1).order(:name)
    @two_hour_courses = Course.where(ce_hours: 2).order(:name)
    @three_hour_courses = Course.where(ce_hours: 3).order(:name)
  end

  def complete
    if current_member.has_completed_course?(@course)
      flash[:notice] = "You already completed that course!"
    else
      completion = current_member.course_completions.create(course_id: @course.id, completed_at: Time.now)
      flash[:notice] = "Successfully completed course '#{@course.name}' on #{completion.completed_at.strftime("%B %d, %Y")}"
    end
    redirect_to courses_path
  end

  def not_authorized
  end

  protected

  def find_course
    @course = Course.find(params[:id])
  end

end
