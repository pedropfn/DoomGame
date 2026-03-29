extends OptionButton

func _on_item_selected(index: int) -> void:
	var option = [1, 0.75, 0.5, 0.25]
	var value = option[index]
	get_tree().root.scaling_3d_scale = value
	print(value)
