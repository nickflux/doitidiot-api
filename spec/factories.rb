FactoryGirl.define do
  
  factory :user do
    password              Devise.friendly_token[0,20]
    password_confirmation { password }
    # for location testing 87.106.140.60 = Germany, 207.210.93.245 = USA, 217.23.234.49 = UK
    last_sign_in_ip       '217.23.234.49'
    
    sequence :email do |seq|
      'user_%d@example.com' % seq
    end

    factory :confirmed_user do
      confirmed_at Time.now
    end

    factory :german_user do
      last_sign_in_ip     '87.106.140.60'
    end
        
  end
  
  factory :todo do
    user
    what_to_do "do this thing"
  end
  
  factory :faq do
    faq_group "faq group"
    question  "what is this?"
    answer    "it's a that"
    published true
  end
  
  factory :mail_message do
    message "<b>this is the message</b>"
    message_no_html  "this is the message"
    date_to_send    Date.today
  end
  
  factory :enquiry do
    email "email@example.com"
    message  "this is the message"
  end
  
  factory :redact do
  end
  
end
