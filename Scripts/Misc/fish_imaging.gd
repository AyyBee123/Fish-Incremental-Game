extends Node3D


func _ready() -> void:
	await get_tree().process_frame
	await capture_fish()


func capture_fish() -> void:
	await RenderingServer.frame_post_draw
	
	var image = %SubViewport.get_texture().get_image()
	
	if image.is_empty():
		push_error("Fish thumbnail capture failed: image is empty.")
		return
	
	var error = image.save_png("res://Assets/Screenshots/glassfish.png")
	
	if error == OK:
		print("Fish thumbnail saved!")
	else:
		push_error("Failed to save fish thumbnail: " + str(error))
