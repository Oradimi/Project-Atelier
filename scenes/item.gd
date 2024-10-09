extends Container
class_name Item

@export var data: ItemData

@onready var item_name:= $MarginContainer/VBoxContainer/Name
@onready var item_description:= $MarginContainer/VBoxContainer/Description
@onready var item_icon:= $MarginContainer/VBoxContainer/Icon
@onready var item_shapes:= $MarginContainer/VBoxContainer/Shapes
@onready var item_traits:= $MarginContainer/VBoxContainer/Traits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_item()
	item_name.text = data.name
	item_description.text = data.description
	item_icon.texture = data.icon
	while (item_shapes.get_child_count() < data.shapes.size()):
		var duplicated_child = item_shapes.get_child(0).duplicate()
		item_shapes.add_child(duplicated_child)
	var i = 0
	for item_shape in item_shapes.get_children():
		var j = 0
		for item_tile: ColorRect in item_shape.get_children():
			if (data.shapes[i].shape[j]):
				item_tile.color = data.shapes[i].get_color()
			j += 1
		i += 1

func _enter_tree() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize_item() -> void:
	#var shape_count: int = randi_range(1, 6)
	var shape_count: int = 8
	print("Shape Count: " + str(shape_count))
	for _n in range(0, shape_count):
		data.shapes.append(ShapeData.new())
	for i in range(0, data.shapes.size()):
		data.shapes[i].color = randi_range(0, ShapeData.ItemShapeColor.size() - 1)
		for j in range(0, data.shapes[i].shape.size()):
			data.shapes[i].shape[j] = bool(randi() & 1)
		while !(data.shapes[i].shape[0] || data.shapes[i].shape[1] || data.shapes[i].shape[2]):
			data.shapes[i].shape[0] = data.shapes[i].shape[3]
			data.shapes[i].shape[1] = data.shapes[i].shape[4]
			data.shapes[i].shape[2] = data.shapes[i].shape[5]
			data.shapes[i].shape[3] = data.shapes[i].shape[6]
			data.shapes[i].shape[4] = data.shapes[i].shape[7]
			data.shapes[i].shape[5] = data.shapes[i].shape[8]
			data.shapes[i].shape[6] = false
			data.shapes[i].shape[7] = false
			data.shapes[i].shape[8] = false
		while !(data.shapes[i].shape[0] || data.shapes[i].shape[3]):
			data.shapes[i].shape[0] = data.shapes[i].shape[1]
			data.shapes[i].shape[3] = data.shapes[i].shape[4]
			data.shapes[i].shape[1] = data.shapes[i].shape[2]
			data.shapes[i].shape[4] = data.shapes[i].shape[5]
			data.shapes[i].shape[2] = false
			data.shapes[i].shape[5] = false
