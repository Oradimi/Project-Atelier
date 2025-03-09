extends Node

@export_category("Item Pool")
@export var item_pool: Array[ItemData]

@onready var mushroom_data: ItemData = preload("uid://v8lvh11feefp")
@onready var honey_data: ItemData = preload("uid://bvps7atyy7eoc")
@onready var wood_stick_data: ItemData = preload("uid://bqeb0yc13046k")

@export_category("NPC Pool")
@export var npc_pool: Array[NPCData]

@onready var fanay_data: NPCData = preload("uid://dmpoh847marw5")
@onready var elizabeth_data: NPCData = preload("uid://jneusfb0xcxf")
@onready var kana_data: NPCData = preload("uid://b3n0emj54qe8j")

@export_category("Global Variables")
@export var time: int = 0
@export var inventory: InventoryManager

@export var canvas: CanvasLayer

@export var menu_list: Dictionary[String, PackedScene] = {
	"Synthesize": preload("res://scenes/crafting_menu.tscn"),
}

func _init():
	SignalBus.next_turn.connect(_on_next_turn)
	SignalBus.open_menu.connect(_on_open_menu)

func _ready():
	item_pool = [
		mushroom_data,
		honey_data,
		wood_stick_data,
	]
	
	npc_pool = [
		fanay_data,
		elizabeth_data,
		kana_data,
	]
	
	# initialize UI
	canvas = CanvasLayer.new()
	get_tree().root.add_child.call_deferred(canvas)
	#if canvas.get_child(0) != null:
		#canvas.get_child(0).queue_free()
	var main_menu_scene:= load("uid://cw1161nbagqaj")
	canvas.add_child(main_menu_scene.instantiate())
	
	# initialize game

func _on_next_turn():
	time += 1
	if canvas.get_child(1) != null:
		canvas.get_child(1).queue_free()
	canvas.get_child(0).show()

func _on_open_menu(menu_name: String):
	canvas.get_child(0).hide()
	canvas.add_child(menu_list[menu_name].instantiate())

func get_npc(npc_name: String):
	for i in npc_pool.size():
		if npc_name == npc_pool[i].name:
			return npc_pool[i]
	push_warning("NPC not found: " + npc_name)
	return null

func get_item(item_name: String):
	for i in item_pool.size():
		if item_name == item_pool[i].name:
			return item_pool[i]
	push_warning("Item not found: " + item_name)
	return null
