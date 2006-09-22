ActiveRecord::Schema.define(:version => 1) do

  create_table :named_things do |t|
    t.column :name, :string
  end
    
end