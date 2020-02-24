extends OptionButton

func _ready() -> void:
	for i in range(18):
		add_item(get_parent().get_parent().building_names[i])

