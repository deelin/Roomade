class SearchController < ApplicationController
  def index
    
  end
  
  def search_apartments
    @query = params[:query].strip if params[:query]
    @filter_hash = {
      :bedrooms => {:min => params[:min_bedrooms], :max => params[:max_bedrooms] },
      :bathrooms => {:min => params[:min_bathrooms], :max => params[:max_bathrooms] },
      :roommates => {:min => params[:min_roommates], :max => params[:max_roommates] },
      :rent => {:min => params[:min_price], :max => params[:max_price] },
    }
    @amenities = params[:amenities]
    @sort = params[:sort]
    @page = params[:page].to_i
  
    @apartment_results = Apartment.search(@query, @filter_hash, @sort, @amenities, @page)
    @total_pages = @apartment_results.total_pages
    @apartment_results_hash = @apartment_results.group_by { |apartment| apartment.id }
    
    if @total_pages == 0
      render "no_results.js" and return
    end
    
    if request.xhr?
      render "search_apartments.js" and return
    else
      render "search_apartments.html" and return
    end
    
  end
  
  
  
  
end
