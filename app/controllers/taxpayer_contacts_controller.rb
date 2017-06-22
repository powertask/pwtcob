class TaxpayerContactsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html
  layout 'window'

  def new
    @taxpayer_contact = TaxpayerContact.new
    @taxpayer_contact.taxpayer_id = params[:format]
  end

  def edit
    @taxpayer_contact = TaxpayerContact.find(params[:id])
  end

  def create
    @taxpayer_contact = TaxpayerContact.new(taxpayer_contact_params)
    @taxpayer_contact.save!

    @taxpayer = Taxpayer.find(@taxpayer_contact.taxpayer_id)
    respond_with @taxpayer
    
  rescue ActiveRecord::RecordInvalid => exception
    respond_with @taxpayer_contact
  end

  def update
    @taxpayer_contact = TaxpayerContact.find(params[:id])
    @taxpayer_contact.update_attributes(taxpayer_contact_params)

    @taxpayer = Taxpayer.find(@taxpayer_contact.taxpayer_id)
    respond_with @taxpayer
  end

  private
    def taxpayer_contact_params
      params.require(:taxpayer_contact).permit(:taxpayer_id, :name, :description, :phone, :email)
    end
end
