object false

node( :update_available ){ @update_available }
node( :version, :if => lambda { |m| @update_available } ){ @version }
node( :binary_size, :if => lambda { |m| @update_available } ){ @binary_size }
