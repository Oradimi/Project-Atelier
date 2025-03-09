extends Control


func _on_synthesize_button_down() -> void:
	SignalBus.open_menu.emit()


func _on_farm_button_down() -> void:
	pass # Replace with function body.


func _on_upgrade_button_down() -> void:
	pass # Replace with function body.


func _on_items_button_down() -> void:
	pass # Replace with function body.


func _on_status_button_down() -> void:
	pass # Replace with function body.


func _on_adventurers_button_down() -> void:
	pass # Replace with function body.


func _on_visitor_button_down() -> void:
	SignalBus.next_turn.emit()
