class Notifier < ActionMailer::Base

  def confirmation_instructions(user)
    subject       "Please confirm your account"
    from          "Data Uncovered <catalog@datauncovered.com>"
    recipients    user.email
    sent_on       Time.now
    body          :confirmation_url => confirm_url(user.perishable_token), :user => user
  end

  def welcome_message(user)
    subject       user.openid_identifier ? "Thanks for signing up!" : "Thanks for confirming!"
    from          "Data Uncovered <catalog@datauncovered.com>"
    recipients    user.email
    sent_on       Time.now
    body          :profile_url => profile_url
  end

  def admin_welcome(user)
    subject       "A new account has been created for you!"
    from          "Data Uncovered <catalog@datauncovered.com>"
    recipients    user.email
    sent_on       Time.now
    body          :profile_url => profile_url, :email => user.email, :password => user.password
  end


  def password_reset_instructions(user)
    subject      "Password Reset Instructions"
    from         "Data Uncovered <catalog@datauncovered.com>"
    recipients   user.email
    sent_on      Time.now
    body         :reset_url => reset_url(user.perishable_token)
  end

  def contact_submission(contact_submission)
    subject      "Contact Us: #{contact_submission.title}"
    from         "Data Uncovered <catalog@datauncovered.com>"
    recipients   "Data Uncovered <catalog@datauncovered.com>"
    sent_on      Time.now
    body <<-BLOCK
      From:
      #{contact_submission.name} <#{contact_submission.email}>

      Comments:
      #{contact_submission.comments}

      Admin URL:
      #{admin_contact_submission_path(contact_submission)}
    BLOCK
  end

  def data_suggestion(data_suggestion)
    subject      "Data Suggestion: #{data_suggestion.title}"
    from         "Data Uncovered <catalog@datauncovered.com>"
    recipients   "Data Uncovered <catalog@datauncovered.com>"
    sent_on      Time.now
    body <<-BLOCK
      From:
      #{data_suggestion.name} <#{data_suggestion.email}>

      Data Record Title:
      #{data_suggestion.title}

      Data Record URL:
      #{data_suggestion.url}

      Comments:
      #{data_suggestion.comments}

      Admin URL:
      #{admin_contact_submission_path(data_suggestion)}
    BLOCK
  end

  def data_record_alert(alert, record)
    subject "New Data Record Alert"
    from "Data Uncovered <catalog@datauncovered.com>"
    recipients "#{alert.user.name} <#{alert.user.email}>"
    sent_on Time.now
    content_type 'text/html'
    body :alert => alert, :user => alert.user, :record => record
  end

  def data_record_report(data_record, report)
    subject "Problem with Data Record"
    from "Data Uncovered <catalog@datauncovered.com>"
    recipients "#{data_record.owner.email}, natdatcat@sunlightfoundation.com"
    sent_on Time.now
    content_type 'text/html'
    body :data_record => data_record, :report => report
  end

  def contest_registration(registration)
    subject "Data Uncovered - Contest Entry"
    from "Data Uncovered <catalog@datauncovered.com>"
    recipients "#{registration.user.email}"
    bcc "catalog@datauncovered.com"
    sent_on Time.now
    body :registration => registration, :user => registration.user
  end

  def contest_entry(registration, entry)
    subject "Data Uncovered - Contest Registration"
    from "Data Uncovered <catalog@datauncovered.com>"
    recipients "#{registration.user.email}"
    bcc "catalog@datauncovered.com"
    sent_on Time.now
    body :registration => registration, :entry => entry
  end

end
