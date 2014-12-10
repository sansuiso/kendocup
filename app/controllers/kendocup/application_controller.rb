require 'cancancan'
module Kendocup
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_filter :configure_permitted_parameters, if: :devise_controller?
    before_filter :set_locale, :set_cup
    before_filter :store_location_if_html, :only => [:index, :show]

    rescue_from CanCan::AccessDenied do |exception|
      # Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      if current_user.present?
        redirect_to root_path, alert: exception.message, status: 401
      else
        redirect_to new_user_session_path, alert: I18n.t("devise.failure.unauthenticated")
      end
    end

    def current_ability
      @current_ability ||= KendocupAbility.new(current_user)
    end

    def default_url_options
      default_url_options = {}
      default_url_options[:locale] = I18n.locale if params[:locale].blank?
      # default_url_options[:year] = Date.current.year if params[:year].blank?
      return default_url_options
    end

    def set_locale
      if flash
        notice = notice
        alert = alert
      end
      default_locale = 'en'
      begin
        request_language = request.env['HTTP_ACCEPT_LANGUAGE'].split('-')[0]
        request_language = (request_language.nil? || !['en', 'fr'].include?(request_language[/[^,;]+/])) ? nil : request_language[/[^,;]+/]
        params_locale = params[:locale] if params[:locale] == 'en' or params[:locale] == 'fr'

        @locale = params_locale || session[:locale] || request_language || default_locale
        I18n.locale = session[:locale] = @locale

        @inverse_locale = (@locale == 'en' ? 'fr' : 'en')

      rescue
        I18n.locale = session[:locale] = default_locale
      end
    end

    # restrict access to admin module for non-admin users
    def authenticate_admin_user!
      redirect_to root_url unless current_user.try(:admin?)
    end

    def back
      redirect_back_or_default
    end

    def redirect_back_or_default(default=root_path, options={})
      redirect_to(session[:return_to] || default, options)
      session[:return_to] = nil
    end

  protected

    def configure_permitted_parameters
      unless current_user_admin?
        devise_parameter_sanitizer.for(:sign_up) << :admin
      end
    end

    def current_user_admin?
      user_signed_in? && current_user.admin?
    end

    def set_cup
      unless @cup.present?
          year = params[:year] ? params[:year] : Date.current.year
          @cup = Cup.where("EXTRACT(YEAR FROM start_on) = ?", year).first
          unless @cup.present?
            raise "Cup is missing!!!"
          end
      end
    end

    def check_deadline
      set_cup
      if !current_user.admin? && Time.current > @cup.deadline
        redirect_back_or_default root_path, alert:  t('kenshis.deadline_passed', email: 'info@kendo-geneve.ch')
        return
      end
    end

    def store_location_if_html
      store_location if ['text/html', 'application/javascript', 'text/javascript'].include?(request.format) && !['application/json'].include?(request.format)
    end

    def store_location
      session[:return_to] = request.fullpath
    end
  end
end
