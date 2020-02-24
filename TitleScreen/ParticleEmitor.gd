tool
extends Particles2D

var _button: Button = null

func _ready() -> void:
	_button = get_parent() as Button
	var box := _button.rect_size / 2
	position = Vector2(box)
	(process_material as ParticlesMaterial).emission_box_extents = Vector3(box.x, box.y, 0)
	emitting = false

func _on_ParticleButton_mouse_entered() -> void:
	emitting = true

func _on_ParticleButton_mouse_exited() -> void:
	emitting = false
