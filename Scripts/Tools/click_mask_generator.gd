@tool
extends EditorScript

func _run() -> void:
	var selected_paths: PackedStringArray = EditorInterface.get_selected_paths()
	if selected_paths.is_empty(): return
	
	for path in selected_paths:
		if path.ends_with(".png") and FileAccess.file_exists(path):
			var tex: Texture2D = load(path)
			var img: Image = tex.get_image()
			var bm: BitMap = BitMap.new()
			bm.create_from_image_alpha(img, 0.5) # 0.5 threshold ignores shadows
			var destination: String = path.get_basename() + "_click_mask.res"
			ResourceSaver.save(bm, destination)
	EditorInterface.get_resource_filesystem().scan()
