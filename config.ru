#\ -s puma

require_relative 'api'

map '/api' do
  run CruchotHq::Api
end
