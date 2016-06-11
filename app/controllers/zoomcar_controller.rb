class ZoomcarController < ApplicationController
  def index

  end

  def search
  	# render json: { status: params[:city], message: params[:pickup], message2: params[:dropoff] }
  	token = "this_is_the_token"
  	search = ZoomcarOtg::Search.new(token)
  	results = 
  	results = search.airport({ :city => params[:city], :starts => params[:pickup], :ends => params[:dropoff] })
  	res = {"cars":[{"id":1,"seater":5,"name":"Figo","url":"http://s3-ap-southeast-1.amazonaws.com/zoomcar/pictures/original/3a1ab1fa8df989804714d57318c1cb42c7c1d213.jpg?-1425200817","brand":"Ford","pricing":[{"id":771,"amount":5185,"kms":365},{"id":772,"amount":6760,"kms":730},{"id":773,"amount":8930,"kms":1095}],"locations":[{"id":"17","starts":"2016-06-12 01:00","ends":"2016-06-15 01:30","pricing":[{"id":771,"amount":5185,"kms":365},{"id":772,"amount":6760,"kms":730},{"id":773,"amount":8930,"kms":1095}]}]}}
  	render json: results
  end

end
