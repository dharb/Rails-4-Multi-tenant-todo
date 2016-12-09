# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

google = Company.where(name: "Google").first_or_create(subdomain: "google")
facebook = Company.where(name: "Facebook").first_or_create(subdomain: "facebook")
larry = User.where(email: "larry@google.com").first_or_create(name: "Larry Page", company_id: google.id, password: "12345678", password_confirmation: "12345678")
sergey = User.where(email: "sergey@google.com").first_or_create(name: "Sergey Brin", company_id: google.id, password: "12345678", password_confirmation: "12345678")
eric = User.where(email: "eric@google.com").first_or_create(name: "Eric Schmidt", company_id: google.id, password: "12345678", password_confirmation: "12345678")
mark = User.where(email: "mark@facebook.com").first_or_create(name: "Mark Zuckerberg", company_id: facebook.id, password: "12345678", password_confirmation: "12345678")
dustin = User.where(email: "dustin@facebook.com").first_or_create(name: "Dustin Moscovitz", company_id: facebook.id, password: "12345678", password_confirmation: "12345678")
eduardo = User.where(email: "eduardo@facebook.com").first_or_create(name: "Eduardo Saverin", company_id: facebook.id, password: "12345678", password_confirmation: "12345678")
Task.where(title: "Finish Development").first_or_create(user_id: larry.id, private: false)
Task.where(title: "Begin Marketing").first_or_create(user_id: sergey.id, private: false)
Task.where(title: "Build Front-end").first_or_create(user_id: eric.id, private: false)
Task.where(title: "Initialize Database").first_or_create(user_id: dustin.id, private: false)
Task.where(title: "Add Tracking Pixel").first_or_create(user_id: dustin.id, private: true)
Task.where(title: "Bring Product to Market").first_or_create(user_id: dustin.id, private: true)
Task.where(title: "Come Up with Product Name").first_or_create(user_id: dustin.id, private: false)
Task.where(title: "Implement Caching").first_or_create(user_id: mark.id, private: true)
Task.where(title: "Segment Data").first_or_create(user_id: mark.id, private: false)
Task.where(title: "Discipline Employees").first_or_create(user_id: mark.id, private: true)
Task.where(title: "Become Millionaire").first_or_create(user_id: mark.id, private: false)
Task.where(title: "Fix Mobile Design").first_or_create(user_id: eduardo.id, private: false)
Task.where(title: "Raise Capital").first_or_create(user_id: eduardo.id, private: true)
Task.where(title: "Pitch VCs").first_or_create(user_id: eduardo.id, private: false)
