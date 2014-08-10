#\ -s puma

require_relative 'api'
require_relative 'admin'

map '/api' do
  run CruchotHq::Api
end

map '/admin' do
  run CruchotHq::Admin
end
