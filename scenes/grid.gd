extends Control

@onready var grid_container:= $HBox/Control/GridContainer
@onready var preview_grid_container:= $HBox/Control/PreviewGridContainer
@onready var grid_tiles: Array[ColorRect]
@onready var preview_grid_tiles: Array[ColorRect]
@onready var item:= $HBox/Item
@onready var end:= $End
@onready var progress_nodes: Array[Node] = [
	$HBox/Colors/ProgressRed,
	$HBox/Colors/ProgressBlue,
	$HBox/Colors/ProgressGreen,
	$HBox/Colors/ProgressYellow,
	$HBox/Colors/ProgressPurple,
]

var currentShapeIndex: int
var offset: Vector2i
var max_offset: Vector2i
var temp_grid_tiles: Array[Color]
var progress: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentShapeIndex = 0

	var children = grid_container.get_children()
	for child in children:
		if child is ColorRect:
			grid_tiles.append(child)
	
	var preview_children = preview_grid_container.get_children()
	for child in preview_children:
		if child is ColorRect:
			grid_tiles.append(child)
			preview_grid_tiles.append(child)

	for i in len(grid_tiles):
		temp_grid_tiles.append(grid_tiles[i].color)
	
	print(get_shape_size(item.data.shapes[currentShapeIndex]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in len(temp_grid_tiles):
		var color_tile = temp_grid_tiles[i]
		grid_tiles[i].color = color_tile

	for color in len(ShapeData.ItemShapeColor):
		progress[color] = 0
		var count = 0
		var tempShape: ShapeData = ShapeData.new()
		tempShape.color = color
		for color_tile in temp_grid_tiles:
			if color_tile == tempShape.get_color():
				progress[color] += 1
		if progress_nodes[color] is Label:
			progress_nodes[color].text = str(progress[color])

	if currentShapeIndex == item.data.shapes.size():
		end.visible = true
		return
	
	var shape_size = get_shape_size(item.data.shapes[currentShapeIndex])
	var grid_size = Vector2i(5, 5)

	max_offset = grid_size - shape_size
	offset.x = clampi(offset.x, 0, max_offset.x)
	offset.y = clampi(offset.y, 0, max_offset.y)

	for i in range(0, 9):
		var id = vector_get_grid_index(get_coords(i, 3) + offset, 5)
		if item.data.shapes[currentShapeIndex].shape[i]:
			preview_grid_tiles[id].color = item.data.shapes[currentShapeIndex].get_color()
		else:
			if id > -1 and id < 25:
				preview_grid_tiles[id].color = Color(0, 0, 0, 0)

	input_manager()

func input_manager():
	if Input.is_action_just_pressed("grid_move_down"):
		offset.y += 1
	if Input.is_action_just_pressed("grid_move_up"):
		offset.y -= 1
	if Input.is_action_just_pressed("grid_move_right"):
		offset.x += 1
	if Input.is_action_just_pressed("grid_move_left"):
		offset.x -= 1
	if Input.is_action_just_pressed("grid_next_ingredient"):
		for i in range(0, 9):
			if item.data.shapes[currentShapeIndex].shape[i]:
				temp_grid_tiles[vector_get_grid_index(get_coords(
					i, 3) + offset, 5)] = item.data.shapes[currentShapeIndex].get_color()
		currentShapeIndex += 1

func get_coords(index: int, size: int) -> Vector2i:
	var x = index % size
	var y = index / size
	return Vector2i(x, y)

func vector_get_grid_index(coords: Vector2i, size: int) -> int:
	return coords.y * size + coords.x

func get_grid_index(x: int, y: int, size: int) -> int:
	return y * size + x

func get_children_of_type(obj, type):
	var children = obj.get_children()
	for child in children:
		if is_instance_of(obj, type):
			grid_tiles.append(child)

func get_shape_size(shapeData: ShapeData) -> Vector2i:
	var min_x = 3
	var min_y = 3
	var max_x = 0
	var max_y = 0
	
	for i in range(0, 9):
		if shapeData.shape[i]:
			var coords = get_coords(i, 3)
			min_x = min(min_x, coords.x)
			min_y = min(min_y, coords.y)
			max_x = max(max_x, coords.x)
			max_y = max(max_y, coords.y)
	
	var width = max_x - min_x + 1
	var height = max_y - min_y + 1

	return Vector2i(width, height)
