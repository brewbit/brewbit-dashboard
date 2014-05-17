object false

@chunk.keys.each do |key|
  node(key){ @chunk[key] }
end