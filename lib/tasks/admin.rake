namespace :admin do
  desc "creates admin"
  task new: :environment do
    print "enter email: "
    email = STDIN.gets.chomp
    print "enter password: "
    password = STDIN.noecho(&:gets).chomp
    u = User.new(first_name: first_name, last_name: last_name, role: 'admin', email: email, password: password)
    if u.save
      puts "\n\ncreated new admin user"
    else
      puts "\n\nfailed to save new admin user"
    end
  end
end
