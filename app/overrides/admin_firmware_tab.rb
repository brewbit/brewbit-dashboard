Deface::Override.new(
  :virtual_path => "spree/admin/shared/_menu",
  :name => 'firmware-tab',
  :insert_bottom => "[data-hook='admin_tabs']",
  :text => "<%= tab(:firmware, url: firmware_index_path) %>"
)
