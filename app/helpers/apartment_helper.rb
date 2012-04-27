module ApartmentHelper
  
  def apt_sum_container_overview(apartment)
    reviews = apartment.reviews
    first_three_reviews = reviews.first(3)
    recommendations = reviews.count(:all, :conditions => {:recommendation => true})
    
    # get photos, if none, use default
    apartment_photos = apartment.apartment_photos
    default_apartment_photo_array = [apartment_photos.first]
    apartment_photos.keep_if{ |photo| photo.photo_file_name != nil }
    apartment_photos = default_apartment_photo_array if apartment_photos.blank?
    
    html = %{
      <div class="apt_detail apt_sum_container grid_12">
  			<div class="inner">
  				<div class="aptname">
  				  #{apartment.name || "No name"}
  				</div>

  				<div class="column">
  					<div class="recommendation-container">
  						<div class="recommendation">
  							<div class="number">#{recommendations}</div>
  							<div class="total">out of #{reviews.length}</div>
  						</div>
  						<div class="text">recommended</div>
  					</div>
  				</div>

  				<div class="column">
  					<div class="aptpicture">#{image_tag(apartment_photos.first.photo.url(:medium))}</div>

  					<div class="aptgallery">
					  }
					    apartment_photos.each do |apartment_photo|
					      html += %{
  						  <div class="aptpicture_small">
    						  #{image_tag(apartment_photo.photo.url(:small))}
    						</div>
    					}
    					end
					  html += %{
  					</div>
  				</div>

  				<div class="column">
				}
				first_three_reviews.each do |review|
				  html += %{
				    <div class="quote-container">
  						<div class="fb_photo-container">
  							<div class="fb_photo">
  							  #{image_tag(review.user.photo.url(:thumb), :size => "40x40")}
  							</div>
  						</div>
  						<div class="quote">
  							"#{review.description}"
  						</div> 
  					</div>

  					<div class="clearfloat"></div>
				  }
			  end
  			html += %{
  				</div>

  				<div class="column buttons_container">
					<div class="button see_more">#{link_to "see more", show_apartment_path(apartment.id)}</div>
  					<div class="button add_queue">add to queue</div>
  				</div>
				
  			</div>
			
  		</div>
	  }
  	return html.html_safe
  end
  
  def apt_sum_container_detail(apartment)
    reviews = apartment.reviews
    amenities = apartment.apartment_amenities.map(&:amenity_id)
    ratings_hash = apartment.get_ratings_hash
    
    address = apartment.address
    street = address.split(",").first
    city_state = address.split(",").second.strip + ", " + address.split(",").third.split(" ").first.strip
    min_rent = reviews.minimum(:rent)
    max_rent = reviews.maximum(:rent)
    min_bedrooms = reviews.minimum(:bedrooms)
    max_bedrooms = reviews.maximum(:bedrooms)
    min_bathrooms = reviews.minimum(:bathrooms)
    max_bathrooms = reviews.maximum(:bathrooms)
    
    html = %{
      <div class="apt_detail grid_12">
  			<div class="inner">
  			  <a href="http://maps.google.com/maps?q=#{address.gsub(" ", "%20")}" target="_blank">
    				<div class="address">
    					<div class="street">#{street}</div>
    					<div class="city">#{city_state}</div>
    				</div> 
  				</a>

  				<div class="column">
  					<div class="map" id="apt_#{apartment.id}_map"></div>

  					<div class="distance" data-address="#{address}" data-apartment-id="#{apartment.id}">
  						<div>#{apartment.dist_to_campus * WALKING_MIN_PER_MILE} min walk to campus</div>
  					</div>

  				</div>

  				<div class="column">

  					<div class="rent">
  						<div class="category">monthly rent
  						</div>

  						<div class="value">
						  }
						  if min_rent == max_rent
						    html += %{~ #{number_to_currency(min_rent)}}
					    else
					      html += %{
  							<div>
  								#{number_to_currency(min_rent)} - 
  							</div>
  							<div>
  								#{number_to_currency(max_rent)}
  							</div>
							}
						end
						html += %{
  						</div>
  					</div>
  				</div>

  				<div class="column">
  					<div class="bedrooms">
  						<div class="category">bedrooms
  						</div>

  						<div class="value"> }
  						if min_bedrooms == max_bedrooms
  						  html += %{~ #{min_bedrooms}}
						  else
						    html += %{#{min_bedrooms}-#{max_bedrooms}}
					    end
  						html += %{
  						</div>
  					</div>


  					<div class="bathrooms">
  						<div class="category">bathrooms
  						</div>

  						<div class="value"> }
  						if min_bathrooms == max_bathrooms
  						  html += %{~ #{min_bathrooms}}
						  else
						    html += %{#{min_bathrooms}-#{max_bathrooms}}
					    end
  						html += %{
  						</div>
  					</div>
  				</div>

  				<div class="column">

  					<div class="amentities">

  						<div class="category">amenities</div>

  						<div class="am_1">
  							<div class="item #{"non-selected" unless amenities.include?(1)}"> laundry machines</div>
  							<div class="item #{"non-selected" unless amenities.include?(2)}"> trash chutes</div>
  							<div class="item #{"non-selected" unless amenities.include?(3)}"> recycling</div>
  							<div class="item #{"non-selected" unless amenities.include?(4)}"> balcony</div>
  							<div class="item #{"non-selected" unless amenities.include?(5)}"> garage</div>
  						</div>

  						<div class="am_2">
  							<div class="item #{"non-selected" unless amenities.include?(6)}"> elevators</div>
  							<div class="item #{"non-selected" unless amenities.include?(7)}"> carpets</div>
  							<div class="item #{"non-selected" unless amenities.include?(8)}"> hardwood floors</div>
  							<div class="item #{"non-selected" unless amenities.include?(9)}"> heaters</div>
  							<div class="item #{"non-selected" unless amenities.include?(10)}"> bike racks</div>
  						</div>
  					</div>

  				</div> 

  				<div class="column">
  					<div class="noise">
  						<div class="category">noise</div>

  						<div class="ratings">
						    }
                1.upto(5).each do |num|
                  if num <= ratings_hash["noise"]
                    html += %{<div class="ratings_value_box"> </div>}
                  else
                    html += %{<div class="ratings_value_box non-selected"> </div>}
                  end
							  end
							  html += %{
  						</div>
  					</div>

  					<div class="condition">
  						<div class="category">condition</div>

  						<div class="ratings">
						    }
						    1.upto(5).each do |num|
                  if num <= ratings_hash["condition"]
                    html += %{<div class="ratings_value_box"> </div>}
                  else
                    html += %{<div class="ratings_value_box non-selected"> </div>}
                  end
							  end
							  html += %{
  						</div>
  					</div>

  					<div class="management">
  						<div class="category">security
  						</div>

  						<div class="ratings">
  							}
						    1.upto(5).each do |num|
                  if num <= ratings_hash["security_level"]
                    html += %{<div class="ratings_value_box"> </div>}
                  else
                    html += %{<div class="ratings_value_box non-selected"> </div>}
                  end
							  end
							  html += %{
  						</div>
  					</div>

  				</div>

  				<div class="num_roomates">
  				</div>


  				<div class="column buttons_container">
  					<div class="button see_more" data-apartment-id="#{apartment.id}">see more</div>
  					<div class="button add_queue" data-apartment-id="#{apartment.id}">add to queue</div>
  				</div>
  			</div>

  		</div>
		}
		return html.html_safe
  end
end
