Dir[Rails.root.join('app/queries/**/*.rb')].each { |f| require f }