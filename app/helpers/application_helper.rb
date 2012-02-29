module ApplicationHelper
	def sortable(column, title = nil)
		title ||= column.titleize
		css_class = column == sort_column ? "current #{sort_direction}" : nil
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		link_to title, "/search?sort=#{column}&direction=#{direction}&q=#{params[:q]}", {:class => css_class}
	end

	def sort_column
		Recipe.column_names.include?(params[:sort]) ? params[:sort] : "rating_count"
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
	end
end
