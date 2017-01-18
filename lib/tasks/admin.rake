namespace :admin do
  desc "Create admin"
  task init: :environment do
    admin = Admin.new email: "admin@gmail.com", password: "password",
      password_confirmation: "password"
    admin.save!
  end

end
