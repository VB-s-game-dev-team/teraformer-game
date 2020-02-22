tool
extends Particles2D

var button: Button

func _ready():
	button = get_parent() as Button
	var box = button.rect_size / 2
	position = Vector2(box)
	(process_material as ParticlesMaterial).emission_box_extents = Vector3(box.x, box.y, 0)
	emitting = false

func _on_ParticleButton_mouse_entered():
	emitting = true

func _on_ParticleButton_mouse_exited():
	emitting = false
