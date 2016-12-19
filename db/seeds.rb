User.create!(name: "User1",
             email: "example@railstutorial.org",
             password: 'password',
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)


29.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = 'password'

  User.create!(name: name,
             email: email,
             password: password,
             password_confirmation: password,
             activated: true,
             activated_at: Time.zone.now)
end

# Microposts
users = User.order(:created_at).take(4)
15.times do |n|
  content = Faker::Lorem.sentences(2).join(" ")
  users.each { |user| user.microposts.create!(content: content)}
end

# Following relationships
users = User.all
user = User.first
following = users[2..20]
followers = users[3..20]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

  # users = User.order(:created_at).take(5)
  # 12.times do |n|
  #   users.each do |user|
  #     user.follow(User.find(n+1))
  #   end
  # end
