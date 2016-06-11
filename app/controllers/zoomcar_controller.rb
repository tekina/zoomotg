class ZoomcarController < ApplicationController

  before_filter :get_auth_token, only: [:create]

  @token = "this_is_the_token"

  def index

  end

  def search
    binding.pry
    search = ZoomcarOtg::Search.new(@token)
    results = search.airport({ :city => params[:city], :starts => params[:pickup], :ends => params[:dropoff] })
    binding.pry
    res = JSON.parse(results)
    data = {}
    res["result"][0]["cars"].each do |r|
      data.merge!({ r["id"] => { location_id: r["locations"][0]["id"], 
        carname: r["brand"] + " " + r["name"], starts: r["locations"][0]["starts"], ends: r["locations"][0]["ends"], 
        city: params[:city], pricing_id: r["locations"][0]["pricing"][1]["id"], 
        amount: r["locations"][0]["pricing"][1]["amount"], kms: r["locations"][0]["pricing"][1]["kms"]
      } })
    end
    @data = data
  end

  def create
    binding.pry
    booking = ZoomcarOtg::Booking.new(@token)
    bkg_data = booking.create({auth_token: @auth_token, city: params[:city], starts: params[:starts], ends: 
      params[:ends], location_id: params[:location_id], cargroup_id: params[:cargroup_id], pricing_id: params[:pricing_id]
      })
    binding.pry
    return bkg_data
  end

  protected

  def get_auth_token
    user = ZoomcarOtg::User.new(@token)
    @auth_token = user.auth_token({:email => 'aniket.garg@zoomcar.com', :name => "Aniket Garg"})
    return auth_token
  end

end
