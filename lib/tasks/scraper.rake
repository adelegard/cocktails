require 'open-uri'


#a 20
#b 18
#c 20
#d 21
# rake scraper:start[a,0]
namespace :scraper do
  task :start, :needs => [:environment] do |t,args|
    letters = ('a'..'z').to_a
    letters.each do |letter|
      url = "http://www.drinksmixer.com/cat/#{letter}"
      
      doc = parse_page(url)
      pages = doc.css(".fl4")[0].text
      pages = pages.slice!(2...pages.size)
      pages = (1..(pages.to_i))
      
      pages.each do |page|
        puts "page: " + page.to_s
        begin
          puts "~~~ Parsing: #{url}/#{page} ~~~"
          doc = parse_page("#{url}/#{page}")
          read_recipe_urls(doc).each do |recipe_url|
            doc = parse_page(recipe_url)
  puts ""
  puts "Letter: " + letter + " page: " + page.to_s
            parse_recipe(doc, recipe_url)
          end
        rescue
          puts "Error parsing page: #{page}"
        end
      end
    end
  end
  
  private
  def read_recipe_urls(doc)
    if doc
      doc.css(".l1a a").collect{|link| "http://www.drinksmixer.com" + link.attribute("href").to_s}
    else
      []
    end
  end
  
  def parse_recipe(doc, recipe_url)
    begin
      title = doc.at_css(".recipe_title").text
      directions = doc.at_css(".RecipeDirections").text
      glass = doc.at_css(".recipeStats img").get_attribute("title")

      rating_avg = ""
      begin
        rating_avg = doc.at_css(".ratingsBox .average").text
      rescue
      end

      rating_count = ""
      begin
        rating_count = doc.at_css(".ratingsBox .count").text
      rescue
      end

      alcoholPercent = ""
      begin
        alcoholPercent = doc.at_css(".recipeStats b").text
      rescue
      end

      # Recipe
      some_recipe = Recipe.where(:title => title, :directions => directions, :glass => glass, :alcohol => alcoholPercent, :rating_avg => rating_avg, :rating_count => rating_count).first
      unless some_recipe
        some_recipe = Recipe.create(:title => title, :directions => directions, :glass => glass, :alcohol => alcoholPercent, :rating_avg => rating_avg, :rating_count => rating_count)
        puts "Created: Recipe #{some_recipe.title}"
      else
        puts "Recipe already exists"
      end

      # Ingredients
      ingredients = []
      doc.css(".recipe_data .ingredient").each_with_index{|ingredient, index|
        amount = ingredient.css(".amount").text
        name = ingredient.css(".name a").text
        ingredients << {:ingredient => name, :amount => amount, :order => index+1}
      }

      ingredients.each do |i|
        some_ingredient = Ingredient.where(:ingredient => i[:ingredient]).first
        unless some_ingredient
          some_ingredient = Ingredient.create(:ingredient => i[:ingredient])
          puts "Created: Ingredient #{i[:ingredient]}"
        else
          puts "Ingredient already exists"
        end

        some_recipe_ingredient = RecipeIngredient.where(:ingredient_id => some_ingredient.id, :recipe_id => some_recipe.id, :amount => i[:amount], :order => i[:order]).first
        unless some_recipe_ingredient
          some_recipe_ingredient = RecipeIngredient.create(:ingredient_id => some_ingredient.id, :recipe_id => some_recipe.id, :amount => i[:amount], :order => i[:order])
          puts "Created: RecipeIngredient ing_id: #{some_recipe_ingredient.ingredient_id} rec_id: #{some_recipe_ingredient.recipe_id}"
        else
          puts "RecipeIngredient already exists"
        end
      end


#puts ""
#puts "Title: " + title
#puts "Ingredients:"
#puts ingredients
#puts "Directions:"
#puts directions
#puts "Glass: " + glass
#puts "Alcohol: " + alcoholPercent

    rescue => e  
      puts "Error parsing #{recipe_url}"
      puts e.message, e.backtrace
    end
  end
  
  def parse_page(url)
    begin
      Nokogiri::HTML(open(url).read)
    rescue => e
      puts "Error opening #{url}"
    end
  end
end