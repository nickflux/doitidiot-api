FactoryGirl.define do
  factory :user do
    password              'let-me-in'
    password_confirmation 'let-me-in'

    sequence :email do |seq|
      'user_%d@example.com' % seq
    end

    factory :confirmed_user do
      confirmed_at Time.now
    end
  end
end
