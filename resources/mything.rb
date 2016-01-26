actions :add, :remove
default_action :add

attribute :path, :kind_of => String, :required => true
attribute :size, :kind_of => [Integer,nil], :required => false, :default => 50

attr_accessor :exists
