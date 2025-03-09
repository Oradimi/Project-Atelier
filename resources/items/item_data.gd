extends Resource
class_name ItemData

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var shapes: Array[ShapeData]
@export var traits: Array[TraitData]
@export var level: int
@export var effect_thresholds: Dictionary

#func _init():
	#shapes.resize(9)
	#shapes.fill(false)
	#traits.resize(3)

#func _init(p_shapes: Array[ItemShape] = [ItemShape.new()]) -> void:
	#var shape_count: int = randi_range(1, 3)
	#print("Shape Count: " + str(shape_count))
	#for _n in range(1, shape_count):
		#p_shapes.append(ItemShape.new())
	#shapes = p_shapes
	#for shape in shapes:
		#print(shape.shape)
