extends Button

func _on_button_down() -> void:
	SignalBus.open_menu.emit(name)
