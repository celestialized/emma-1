class ApplicationController < ActionController::Base
  include Pagy::Backend

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :masquerade_user!

  before_action :collect_sets_for_the_frontdoor

  def collect_sets_for_the_frontdoor
    @upcoming_meetups ||=  Meetup.where('end_date >= ?',  Date.today).order("start_date DESC").first(5)
    @linked_icon_data ||=  PublisherAcct.all_links_and_icons
    @linked_icons_for_footer = ["instagram",  "youtube", "facebook", "twitter", "snapchat", "linkedin", "podcast"]

  end
  # Controllers can call this to add classes to the body tag
  def add_body_css_class(css_class)
    @body_css_classes ||= []
    @body_css_classes << css_class
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
    end
end
