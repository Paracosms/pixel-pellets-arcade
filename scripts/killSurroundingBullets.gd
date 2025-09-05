extends Area2D

# if 'bullet' appears in the first 6 characters of the overlapping node's name, delete it
func clearArea():
	for body in get_overlapping_bodies():
		if body.name.substr(0,6) == "bullet":
			body.queue_free()
