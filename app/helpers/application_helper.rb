module ApplicationHelper
	def flash_class(level)
		case level
			when :notice then "alert alert-info"
			when :success then "alert alert-success"
			when :error then "alert alert-error"
			when :alert then "alert alert-error"
		end
	end
	def flash_strong(level)
		case level
			when :notice then "Heads up!"
			when :success then "Well done!"
			when :error then "Oh snap!"
			when :alert then "Oh snap!"
		end
	end

	def sortable(column, title = nil)
		title ||= column.titleize
		css_class = column == sort_column ? "current #{sort_direction}" : nil
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		link_to title, "/search?sort=#{column}&direction=#{direction}&q=#{params[:q]}&spirit=#{params[:spirit]}", {:class => css_class}
	end

	def sort_column
		Recipe.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
	end

	def default_tastes
	  # this should be CACHED!!! ...really it shouldn't even be here.
	  ['Tasty', 'Refreshing', 'Gross', 'Perfect', 'Too Strong', 'Too Bitter']
	end
	
	def default_spirits
	  # this should be CACHED!!! ...really it shouldn't even be here.
	  ['Vodka', 'Rum', 'Gin', 'Tequila', 'Whiskey', 'Champagne']
	end

	def default_ingredients
	  # this should be CACHED!!! ...really it shouldn't even be here.
	  ['Water', 'Milk', 'Ice', 'Vanilla', 'Sugar']
	end
end
