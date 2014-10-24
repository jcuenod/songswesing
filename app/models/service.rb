class Service < ActiveRecord::Base
  belongs_to :leader
  belongs_to :service_type
  has_many	:usages
  has_many	:songs,
  			:through => :usages
  accepts_nested_attributes_for :songs,
  			:reject_if => :all_blank
end
