PublicActivity.enabled = false
# booking types
BookingType.create name: "Hour"
BookingType.create name: "Day"
BookingType.create name: "Week"
BookingType.create name: "Month"

# create_user 1
user = User.new name: "Test User 1", email: "testuser1@gmail.com",
  password: "password", password_confirmation: "password"
user.skip_confirmation!
user.save!

# create_user 2
user = User.new name: "Test User 2", email: "testuser2@gmail.com",
  password: "password", password_confirmation: "password"
user.skip_confirmation!
user.save!

# create_user 3
user = User.new name: "Doan", email: "le.dinh.doan@framgia.com",
  password: "doan1234", password_confirmation: "doan1234"
user.skip_confirmation!
user.save!

# create_user 4
user = User.new name: "Giang", email: "le.xuan.giang@framgia.com",
  password: "12345678", password_confirmation: "12345678"
user.skip_confirmation!
user.save!

# Create some users
100.times do |n|
  user = User.new name: Faker::Name.name, email: "example-#{n + 1}@gmail.com",
    password: "password", password_confirmation: "password",
    created_at: rand(2.years.ago..Time.now)
  user.skip_confirmation!
  user.save!
end

#Create price_types
3.times do |n|
  case n
  when 0
    content = "day"
  when 1
    content = "month"
  when 2
    content = "year"
  end
  PriceType.create! content: content
end

#Create default amenity
5.times do |n|
  case n
  when 0
    name = "WiFi"
    description = "We will service you the highest speed WiFi"
  when 1
    name = "Cafe/ Restaurant"
    description = "We will service you truly Cafe"
  when 2
    name = "Coffee/ Tea/ Filtered Water"
    description = "We have coffee/ tea/ filtered water"
  when 3
    name = "Pets allowed"
    description = "Pet is welcome in our spaces"
  when 4
    name = "Lockers"
    description = "Everyone will have personal locker when come here"
  end
  amenity = Amenity.create! name: name, description: description, is_free: true,
    is_default: true
  ServiceCharge.create! amenity_id: amenity.id, price_type_id: 1, price: 1000
end

# create_address
address1 = Address.create! details: "Parkson Da Nang, Hung Vuong,
  Vinh Trung, Da Nang, Vietnam"
address2 = Address.create! details: "Hotel Novotel Danang Premier Han River,
  Da Nang, Vietnam"

venue1 = Venue.new name: Faker::Name.name,
  phone_number: '0511 3 1234567',
  email: Faker::Internet.email,
  description: Faker::Lorem.paragraph, address: address1,
  status: true

image1 = Image.new picture: Rack::Test::UploadedFile.new(File.join(Rails.root, "public", "images",
  "spaces", "space1.jpg"))
image2 = Image.new picture: Rack::Test::UploadedFile.new(File.join(Rails.root, "public", "images",
  "spaces", "space1.jpg"))
image3 = Image.new picture: Rack::Test::UploadedFile.new(File.join(Rails.root, "public", "images",
  "spaces", "space1.jpg"))
image4 = Image.new picture: Rack::Test::UploadedFile.new(File.join(Rails.root, "public", "images",
  "spaces", "space1.jpg"))

space1 = Space.new name: Faker::Name.name ,space_type: :prive_office, area: 10, capicity: 4,
  quantity: 2, description: Faker::Lorem.paragraph
space1.images << image1
venue1.spaces << space1

space2 = Space.new name: Faker::Name.name, space_type: :desk, area: 10, capicity: 4, quantity: 2,
  description: Faker::Lorem.paragraph
space2.images << image2
venue1.spaces << space2
venue1.save

venue2 = Venue.new name: Faker::Name.name,
  phone_number: '0511 3 2343444',
  email: Faker::Internet.email,
  description: Faker::Lorem.paragraph, address: address2
space3 = Space.new name: Faker::Name.name, space_type: :desk, area: 10, capicity: 4, quantity: 2,
  description: Faker::Lorem.paragraph
space3.images << image3
venue2.spaces << space3

space4 = Space.new name: Faker::Name.name, space_type: :desk, area: 10, capicity: 4, quantity: 2,
  description: Faker::Lorem.paragraph
space4.images << image4
venue2.spaces << space4

venue2.save

10.times do |n|
  space =  Space.create! name: Faker::Name.name, space_type: :desk, area: 10, capicity: 4, quantity: 2, description: Faker::Lorem.paragraph
  venue2.spaces << space
  venue2.save
end

# create_working_time
from = Time.zone.local(1, 1, 1, 8, 00, 00)
to = Time.zone.local(1, 1, 1, 18, 00, 00)

# Create User_Role_venue
UserRoleVenue.create user_id: 1, venue_id: 1, type_role: 1, old_owner: User.first
UserRoleVenue.create user_id: 1, venue_id: 2, type_role: 1, old_owner: User.first
#create_price_for_space
Price.all.destroy_all
Space.all.each do |space|
  BookingType.all.each do |booking_type|
    price = 0
    case booking_type.name
    when "Hour"
      price = 1
    when "Day"
      price = 24
    when "Week"
      price = 168
    when "Month"
      price = 5040
    end
    Price.create space: space, booking_type: booking_type, price: price
  end
end
PublicActivity.enabled = true
