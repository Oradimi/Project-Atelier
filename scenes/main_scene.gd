extends Node

func _init():
	SignalBus.next_turn.connect(_on_next_turn)
	SignalBus.open_menu.connect(_on_open_menu)

func _on_next_turn():
	$OutsideCamera.current = true
	var random_npc_id : int = randi_range(0, GameManager.npc_pool.size() - 1)
	for i in randi_range(1, 4):
		var random_item_id: int = randi_range(0, GameManager.item_pool.size() - 1)
		GameManager.npc_pool[random_npc_id].carrying_items.append(
			Item.create(GameManager.item_pool[random_item_id]).data)
	InventoryManager.item_list.append_array(GameManager.npc_pool[random_npc_id].carrying_items)
	instantiate_under(GameManager.npc_pool[random_npc_id].model, $NPCPosition)

func _on_open_menu():
	$InsideCamera.current = true

func instantiate_under(object: PackedScene, node: Node3D) -> Node3D:
	var instance = object.instantiate()
	node.add_child(instance)
	return instance
