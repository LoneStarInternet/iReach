class MemberMailer < ActionMailer::Base
  default from: 'updates@texashearingaidassoc.com'

  def member_updated( member_id )
    @member = Member.find( member_id )
    mail(to: 'scott@association-mgt.com',
      subject: "#{@member.first_name} #{@member.last_name} changed membership information"
    )
  end
end
