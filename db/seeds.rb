# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

p '============ sheet create start ============='

('a'..'c').each do |row|
  ('1'..'5').each do |column|
    Sheet.create(column: column, row: row)
  end
end

p '============ sheet create end ============='


p '============ screen create start ============='

Screen.create(name: 'Screen 1', description: 'Screen 1 description')
Screen.create(name: 'Screen 2', description: 'Screen 2 description')
Screen.create(name: 'Screen 3', description: 'Screen 3 description')

p '============ screen create end ============='
