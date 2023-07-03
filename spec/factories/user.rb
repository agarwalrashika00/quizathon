FactoryBot.define do
  factory :user do
      email { "abcd@gmail.com" }
      password { "abcdef" }
      password_confirmation { "abcdef" }
      blocked { false }

      trait :admin do
        email { "admin@gmail.com" }
        password { 'Adminn' }
        password_confirmation { 'Adminn' }
        role { 'admin' }
        blocked { false }
      end
  end
end
