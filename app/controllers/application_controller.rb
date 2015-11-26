require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  layout 'application'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
	I18n.locale = "pt-BR"

 private

    def index_class(klass, options = {})
      options[:order] = true if options[:order].nil?

      if params[:name].nil?
        list(klass, options)
      else
        filter_class(klass, options)
      end
    end

    def filter_class(klass, options = {})
      if params[:name].empty?
        list(klass, options)
      else
        list(klass, options).where("lower(name) like ?", params[:name].downcase << "%")
      end
    end

    def list(klass, options = {})
      if options[:type].nil?
        k = klass.where("unit_id = ?", session[:unit_id]).paginate(:page => params[:page], :per_page => 20)
        
        if options[:order]
          k = k.order('name ASC')
        end
        k
        
      elsif options[:type] == :id
        klass.where('id = ?', session[:unit_id])
      else
        k = klass.all.paginate(:page => params[:page], :per_page => 20)
        k = k.order('name ASC') unless options[:order]
      end
    end
end
