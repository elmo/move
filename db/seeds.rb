# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
[ 'Stairs', 'Elevator', 'None' ].each do |name|
  LoadingStair.find_or_create_by!(name: name)
end

[ 'Stairs', 'Elevator', 'None' ].each do |name|
  UnloadingStair.find_or_create_by!(name: name)
end

User.create(
  first_name: "System",
  last_name: "User",
  email_address: "info@arrowlinemoving.com",
  password: "N0Password!",
  password_confirmation: "N0Password!",
) unless User.exists?(email_address: "info@arrowlinemoving.com")
