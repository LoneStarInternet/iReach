class MemberController < ApplicationController

  respond_to :html, :pdf, only: [:personal_tracking_report]

  load_and_authorize_resource
  

  def index
      redirect_to :action => 'edit'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  #        :redirect_to => { :action => :show }

  def show
    @member = Member.find( current_member.id )
  end

  def edit
    @member = Member.find( current_member.id )
  end

  def personal_tracking_report

    @member = current_member
    @course_completions = @member.completed_ces
    respond_with(@switches) do |format|
      format.html {render :layout => 'courses'}
      format.pdf do
        return render text: "You must pay your dues to get a Tracking Report!" unless current_member.can_complete_courses?
        errors = ''
        unless params[:license_number].present? 
          errors += "You must enter your License Number!<br/>"
        else
          @member.update_attribute(:license_number,params[:license_number])
        end
        unless params[:license_renewal_date].present? 
          errors += "You must enter your License Renewal Date!<br/>"
        end
        renewal_date = Date.strptime(params[:license_renewal_date], "%m/%d/%Y") rescue nil
        if renewal_date.nil?
          # formatting error/invalid date
          errors += "Sorry, the date you entered was not valid. It should be mm/dd/yyyy. Try using the date selector."
        end
        if errors.present?
          flash[:notice] = errors.html_safe
          return redirect_to member_personal_tracking_report_path
        end
        return send_file(@member.personal_tracking_report(renewal_date.to_s).path, :filename => "PersonalTrackingReport.pdf",
          :type => 'application/pdf', :x_sendfile => true)# if @member.personal_tracking_report_generated?(params[:license_renewal_date])
        # redirect_to member_personal_tracking_report_path(license_renewal_date: params[:license_renewal_date])
      end
    end
  end

  def update
    @member = Member.find(current_member.id)
    if @member.update_attributes(params[:member])
      flash[:notice] = 'Member information successfully updated.'
      MemberMailer.delay(queue: :rails3).member_updated(@member.id )
      redirect_to :action => 'edit'
    else
      render :action => 'edit'
    end
  end

   def article
   
      @file = params[:id]
      @format = params[:format]

      fixed = @file + "." + @format

       filePath = File.join(Rails.root, "/public/protected/", fixed )
      #filePath = '/home/httpd/texashearingaids/html/protected/' + fixed 

      logger.error( " trying to build: " + filePath )

      send_file filePath, :type => 'text/html', :disposition => 'inline'
      
   end

   def edit_password
     @member = current_member
   end

   def update_password
     @member = current_member
     if @member.update_attributes(params[:member])
       sign_in(current_member, :bypass => true)
       # flash[:notice] = 'Password successfully updated.'
       MemberMailer.delay(queue: :rails3).member_updated(@member.id )
       redirect_to root_path
     else
       render :action => 'edit_password'
     end
   end

   def pdfdocument

      @file = params[:id]
      @format = params[:format]

      fixed = @file + "." + @format

       filePath = File.join(Rails.root, "/public/protected/", fixed )
      #filePath = '/home/httpd/texashearingaids/html/protected/' + fixed 

      logger.error( " trying to build: " + filePath )

      send_file filePath, :type => 'application/pdf', :disposition => 'inline'

   end

   def static_login
      @member = Member.new
      render layout: false
   end

  # xhr request to see if their pdf has been generated, will set off a job to generate if needed
  def check_personal_tracking_report_generation
    if current_member.personal_tracking_report_generated?(params[:license_renewal_date])
      render :update do |page|
        page['#generating_pdf_indicator'].remove()
        page['#download_pdf'].show()
        page << "check_for_pdf_poller.stop();"
      end
    else
      @member.personal_tracking_report(params[:license_renewal_date])
      render json: {}
    end
  end

  def not_authorized
  end

end
