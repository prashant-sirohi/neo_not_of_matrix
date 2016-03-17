class Category 
  include Neo4j::ActiveNode
  id_property :i_d
  property :name, type: String
  has_one :in, :book, origin: :category


end
