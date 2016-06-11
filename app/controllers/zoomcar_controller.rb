class ZoomcarController < ApplicationController

  before_filter :get_auth_token, only: [:create, :confirm]

  def index

  end

  def search
    @token = "this_is_the_token"
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
    @token = "this_is_the_token"
    booking = ZoomcarOtg::Booking.new(@token)
    bkg_data = booking.create({auth_token: @auth_token, city: params[:city], starts: params[:starts], ends: 
      params[:ends], location_id: params[:location_id], cargroup_id: params[:cargroup_id], pricing_id: params[:pricing_id]
      })
    @data = JSON.parse(bkg_data)
  end

  def confirm
    booking = ZoomcarOtg::Booking.new(@token)
    bkg_data = booking.confirm_payment({:auth_token => @auth_token, :booking_id => params[:booking_id], :amount => params[:amount]})
    @data = JSON.parse(bkg_data).merge!({"booking_id": params[:booking_id]})
  end

  protected

  def get_auth_token
    @token = "this_is_the_token"
    user = ZoomcarOtg::User.new(@token)
    token = user.auth_token({:email => 'aniket.garg@zoomcar.com', :name => "Aniket Garg"}) 
    @auth_token = JSON.parse(token)["auth_token"]
    return @auth_token
  end

end
