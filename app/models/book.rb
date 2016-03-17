class Book < Asset
  include Neo4j::ActiveNode
  include Neo4jrb::Paperclip
  id_property :isbn
  property :year_published, type: Integer
  has_one :in, :author, type: :CREATED, model_class: :User
  has_one :out, :category, type: :HAS_CATEGORY
  validates :isbn, presence: true
  validate :unique_id?
  has_neo4jrb_attached_file :book_image
  validates_attachment_content_type :book_image, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  def unique_id?
  	errors.add(:isbn, "has already been taken") if (Book.all.pluck(:isbn).include? self.isbn)
  end
######################slower search############################################
  # def self.search(search,pages)
  #   if search
  #     # find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  #     s = search.downcase
  #     f_books = []
  #     Book.all.each do |b|
  #       if b.title.downcase =~ /#{s}/i || b.category.name.downcase =~ /#{s}/i
  #         f_books << b
  #       # elsif b.author.name.downcase =~ /#{s}/i
  #       end
  #     end
  #     return Book.where(:isbn => f_books.map(&:isbn)).paginate(:page => pages, :per_page => 20)
  #   end
  # end
################################################################################

#################faster search##################################################
  def self.search(search,pages)
    if search
      search = search.downcase
      @books = []
      Neo4j::Session.query("MATCH (n:Book)-[r]->(c:Category) WHERE lower(n.title) CONTAINS '#{search}' OR ( c.name = '#{search}') RETURN n").each do |x|
        @books << x[:n][:isbn]
      end
      return Book.where(:isbn => @books).paginate(:page => pages, :per_page => 20)
    else
      return nil
    end
  end
#################################################################################

end