ActiveRecord::Base.transaction do
  Supplier.create!(name: 'supplier1', url: 'https://api.myjson.com/bins/2tlb8')
  Supplier.create!(name: 'supplier2', url: 'https://api.myjson.com/bins/42lok')
  Supplier.create!(name: 'supplier3', url: 'https://api.myjson.com/bins/15ktg')
end
