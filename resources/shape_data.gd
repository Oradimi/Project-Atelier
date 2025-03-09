extends Resource
class_name ShapeData

enum ItemShapeColor {
	RED,
	BLUE,
	GREEN,
	YELLOW,
	PURPLE,
}

@export var shape: Array[bool]
@export var color: ItemShapeColor

func _init() -> void:
	shape.resize(9)
	color = ItemShapeColor.RED

func get_color():
	match color:
		ItemShapeColor.RED:
			return Color.RED
		ItemShapeColor.BLUE:
			return Color.BLUE
		ItemShapeColor.GREEN:
			return Color.GREEN
		ItemShapeColor.YELLOW:
			return Color.YELLOW
		ItemShapeColor.PURPLE:
			return Color.PURPLE

#func _init() -> void:
	#var p_color = randi_range(0, ItemShape.ItemShapeColor.size())
	#var p_shape: Array[bool] = []
	#p_shape.resize(9)
	#for j in range(0, p_shape.size()):
		#p_shape[j] = bool(randi() & 1)
	#print("Shape state " + str(p_shape))
	#shape = p_shape
	#color = p_color
