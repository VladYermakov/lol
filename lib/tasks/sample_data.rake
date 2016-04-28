namespace :db do

  desc "Fill database with sample data"
  task populate: :environment do

    make_users
    make_posts

  end

end

def make_users

  10.times do |n|

    name = "user#{n}"
    email = "user#{n}@site#{n}.com"
    password = "password"

    User.create(name: name, email: email, password: password, password_confirmation: password)

  end

end

def make_posts

  users = User.all.limit(3)

  6.times do |n|

    content = Faker::Lorem.sentence(6)
    users.each { |user| user.posts.create!(content: content) }

  end

end
