extends Node

@export var itemList: Array[ItemData]

@onready var mushroomData: ItemData = preload("res://resources/items/mushroom.tres")
@onready var honeyData = preload("res://resources/items/honey.tres")
@onready var woodStickData = preload("res://resources/items/wood_stick.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mushroom: Item = Item.create(mushroomData)
	itemList.append(mushroom.data)
	var mushroom2: Item = Item.create(mushroomData)
	itemList.append(mushroom2.data)
	var honey: Item = Item.create(honeyData)
	itemList.append(honey.data)
	var woodStick: Item = Item.create(woodStickData)
	itemList.append(woodStick.data)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
