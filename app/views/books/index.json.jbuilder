json.array!(@books) do |book|
  json.extract! book, :id, :isbn, :title, :year_published, :author_id, :category_id
  json.url book_url(book, format: :json)
end
