object false

node( :update_available ){ @update_available }
node( :version, :if => lambda { @update_available } ){ @version }
node( :binary_size, :if => lambda { @update_available } ){ @binary_size }
      