class EmbedsController < ApplicationController
  include ActionView::Helpers::AssetUrlHelper
  include Webpacker::Helper

  skip_before_action :authenticate_user!
  protect_from_forgery except: :show

  def show
    respond_to do |format|
      format.js  { redirect_to sources_from_manifest_entries(["embed"], type: :javascript).first }
      format.css { redirect_to sources_from_manifest_entries(["embed"], type: :stylesheet).first }
    end
  end
end
