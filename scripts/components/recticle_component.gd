extends Control

# this component controls the display of a target
# recticle on the screen

func on():
	visible = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($MeshInstance3D, "albedo_color:a", 1.0, 0.05)
	

func off():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($MeshInstance3D, "albedo_color:a", 0.0, 0.05)
	visible = false
	
func aim(pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "position", pos, 1)
	#position = pos
	
func engage():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($MeshInstance3D, "albedo_color", Color8(156, 214, 0), 0.05)
	#$MeshInstance3D.albedo_color = Color8(156, 214, 0)
	
func disengage():
	var tween = create_tween()
	tween.tween_property($MeshInstance3D, "albedo_color", Color8(152, 0, 59), 0.05)
	#$MeshInstance3D.albedo_color = Color8(152, 0, 59)
