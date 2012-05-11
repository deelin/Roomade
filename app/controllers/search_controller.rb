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
    @page = params[:page]
  
    @apartment_results_hash = Apartment.search(@query, @filter_hash, @sort, @amenities, @page)
  
    if @apartment_results_hash.present?
      
    else
      # no results
    end
    
    if request.xhr?
      render "search_apartments.js" and return
    else
      render "search_apartments.html" and return
    end
    
  end
  
  
  
  
end
