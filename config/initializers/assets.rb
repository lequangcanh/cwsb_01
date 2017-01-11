# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(search/search.js
  search/show_space.js map amenity/edit.js amenity/new.js amenity/index.js
  static_pages.js booking/index.js booking_history/index.js toggle-switch.css
  store_bookings/show.js cable.js booking_history/delete_booking.js
  booking_history/calculate_price.js venue_market/edit.js
  booking_history/payment_directly.js confirm_payment_directlies/show.js
  confirm_payment_bankings/show.js admin/venues.js)
