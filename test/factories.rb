FactoryGirl.define do

  # Ingredients
  factory :ingredient do
    ingredient "ingredient"
  end

  factory :gin, class: Ingredient do
    ingredient "gin"
  end

  factory :tonic, class: Ingredient do
    ingredient "tonic"
  end

  # Recipes
  factory :recipe do
    title "Recipe"
    servings 1
    after(:build) do |recipe|
      recipe.ingredients << FactoryGirl.build(:ingredient)
    end
  end

  factory :gin_and_tonic, class: Recipe do
    title "gin and tonic"
    servings 1
    after(:build) do |recipe| 
      recipe.ingredients << FactoryGirl.build(:gin)
      recipe.ingredients << FactoryGirl.build(:tonic)
    end
  end

end