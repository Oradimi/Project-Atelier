extends Control

@onready var grid_container:= $HBox/Control/GridContainer
@onready var preview_grid_container:= $HBox/Control/PreviewGridContainer
@onready var shapes:= $HBox/Tiles/Shapes
@onready var shapeID:= $ShapeID
@onready var grid_tiles: Array[ColorRect]
@onready var preview_grid_tiles: Array[ColorRect]
@onready var item:= $Item
@onready var end:= $End
@onready var graveyard:= $HBox/Tiles/Graveyard
@onready var progress_nodes: Array[Node] = [
	$HBox/Colors/ProgressRed,
	$HBox/Colors/ProgressBlue,
	$HBox/Colors/ProgressGreen,
	$HBox/Colors/ProgressYellow,
	$HBox/Colors/ProgressPurple,
]

@export var selectedItems: Array[ItemData]
@export var shapeList: Array[ShapeData]
@export var selectedShape: ShapeData

var currentShapeIndex: int
var offset: Vector2i
var max_offset: Vector2i
var temp_grid_tiles: Array[Color]
var progress: Dictionary

enum SelectionState {
	SHAPE,
	PLACEMENT,
}

var selectionState: SelectionState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentShapeIndex = 0
	selectionState = SelectionState.SHAPE

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match selectionState:
		SelectionState.SHAPE:
			process_shape()
		SelectionState.PLACEMENT:
			process_placement()

func process_shape():
	if shapes.get_child_count() <= 1:
		return
	if Input.is_action_just_pressed("grid_move_down"):
		currentShapeIndex += 1
	if Input.is_action_just_pressed("grid_move_up"):
		currentShapeIndex -= 1
	if Input.is_action_just_pressed("grid_next_ingredient"):
		selectionState = SelectionState.PLACEMENT
		selectedShape = shapeList.pop_at(currentShapeIndex)
		shapes.get_child(currentShapeIndex + 1).reparent(graveyard)
	currentShapeIndex = clampi(currentShapeIndex, 0, max(0, shapeList.size() - 1))
	shapeID.text = "Selected Shape ID: " + str(currentShapeIndex)

func update_grid():
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
	
	if shapeList.is_empty() and selectedShape == null:
		end.visible = true
		return
	else:
		end.visible = false

func process_placement():
	update_grid()
	
	var shape_size = get_shape_size(selectedShape)
	var grid_size = Vector2i(5, 5)

	max_offset = grid_size - shape_size
	offset.x = clampi(offset.x, 0, max_offset.x)
	offset.y = clampi(offset.y, 0, max_offset.y)

	for i in range(0, 9):
		var id = vector_get_grid_index(get_coords(i, 3) + offset, 5)
		if selectedShape.shape[i]:
			preview_grid_tiles[id].color = selectedShape.get_color()
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
	if Input.is_action_just_pressed("grid_rotate_counterclockwise"):
		var shape_size = get_shape_size(selectedShape)
		selectedShape.shape = rotate_shape_counterclockwise(
				selectedShape.shape, shape_size)
	if Input.is_action_just_pressed("grid_rotate_clockwise"):
		var shape_size = get_shape_size(selectedShape)
		selectedShape.shape = rotate_shape_clockwise(
				selectedShape.shape, shape_size)
	if Input.is_action_just_pressed("grid_next_ingredient"):
		for i in range(0, 9):
			if selectedShape.shape[i]:
				temp_grid_tiles[vector_get_grid_index(get_coords(
						i, 3) + offset, 5)] = selectedShape.get_color()
		selectionState = SelectionState.SHAPE
		selectedShape = null
		update_grid()

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

# Rotates a shape clockwise
func rotate_shape_counterclockwise(shape: Array[bool], size: Vector2i) -> Array[bool]:
	if size == Vector2i(1, 1):
		return shape

	var rotated_shape: Array[bool] = []
	rotated_shape.resize(9)

	for y in range(3):
		for x in range(3):
			var new_x = y
			var new_y = 2 - x
			var old_index = get_grid_index(x, y, 3)
			var new_index = get_grid_index(new_x, new_y, 3)
			rotated_shape[new_index] = shape[old_index]
	
	return align_shape_to_top_left(rotated_shape, 3)

func rotate_shape_clockwise(shape: Array[bool], size: Vector2i) -> Array[bool]:
	if size == Vector2i(1, 1):
		return shape

	var rotated_shape: Array[bool] = []
	rotated_shape.resize(9)
	
	for y in range(3):
		for x in range(3):
			var new_x = 2 - y
			var new_y = x
			var old_index = get_grid_index(x, y, 3)
			var new_index = get_grid_index(new_x, new_y, 3)
			rotated_shape[new_index] = shape[old_index]
	
	return align_shape_to_top_left(rotated_shape, 3)

# Ensures the shape stays in the top-left of its bounding box
func align_shape_to_top_left(shape: Array[bool], size: int) -> Array[bool]:
	var min_x = size
	var min_y = size

	for y in range(3):
		for x in range(3):
			var index = get_grid_index(x, y, 3)
			if shape[index]:
				min_x = min(min_x, x)
				min_y = min(min_y, y)

	var aligned_shape: Array[bool] = []
	aligned_shape.resize(9)

	for y in range(3):
		for x in range(3):
			var old_index = get_grid_index(x, y, 3)
			var new_x = x - min_x
			var new_y = y - min_y

			if new_x >= 0 and new_y >= 0 and new_x < 3 and new_y < 3:
				var new_index = get_grid_index(new_x, new_y, 3)
				aligned_shape[new_index] = shape[old_index]

	return aligned_shape
