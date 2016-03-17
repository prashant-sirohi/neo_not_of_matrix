namespace :bulk_create do
	desc "TODO"
	task books: :environment do
		(10001..20000).each do |i|
			Book.create(:isbn => i,
									:title => (0...8).map { (65 + rand(26)).chr }.join,
									:year_published => 2016,
									:author => User.first,
									:categories => Category.find("#{rand(1..9)}"))
		end 
	end
end