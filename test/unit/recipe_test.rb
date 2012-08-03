require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

  context "#total_ratings" do
    setup do
      @recipes = [FactoryGirl.create(:gin_and_tonic, rating_count: 5), FactoryGirl.create(:recipe, rating_count: 3)]
    end
    
    should "return the sum of all rating_count of recipes passed to it" do
      assert_equal Recipe.total_ratings(@recipes), 8
    end

    should "return 0 if no recipes are passed" do
      assert_equal Recipe.total_ratings([]), 0
    end

  end

end
