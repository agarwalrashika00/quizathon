namespace :genres do
  desc "seed basic genres"
  task seed: :environment do
    seed_data = [{title: 'Ruby'}, 
      {title: 'Advance Ruby', description: 'Metaprogramming in ruby', super_genre_id: 1}, 
      {title: 'Frontend', description: 'Beautiful sites you see'}, 
      {title: 'Html', description: 'basic site design you see', super_genre_id: 3}, 
      {title: 'CSS', description: 'beautify your basic layout', super_genre_id: 3}, 
      {title: 'Javascript', description: 'Web logic', super_genre_id: 3}, 
      {title: 'React', description: 'SPA', super_genre_id: 3}]
    seed_data.each do |data|
      g = Genre.new(data)
      if g.save
         puts "\n\ncreated new genre #{g.title}"
      else
        puts g.errors.to_a
      end
    end
  end
end
