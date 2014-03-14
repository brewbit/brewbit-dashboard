class ApiKey < ActiveRecord::Base
  before_validation :generate_token

  belongs_to :user, class_name: 'Spree::User'

  private

  def generate_token
    begin
      self[:access_token] = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end

