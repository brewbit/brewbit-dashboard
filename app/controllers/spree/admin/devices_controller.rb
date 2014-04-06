require 'device'

module Spree
  module Admin
    class DevicesController < Spree::Admin::BaseController

      def index
        @devices = ::Device.all
      end
    end
  end
end
