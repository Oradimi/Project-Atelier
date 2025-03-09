extends Control

@onready var recipeSelection = $RecipeSelection
@onready var recipeName = $RecipeSelection/HBoxContainer/Recipe/MarginContainer/VBoxContainer/Name
@onready var recipeIcon = $RecipeSelection/HBoxContainer/Recipe/MarginContainer/VBoxContainer/Icon
@onready var recipeDesc = $RecipeSelection/HBoxContainer/Recipe/MarginContainer/VBoxContainer/Description
@onready var recipeList: Array[ItemData]

@onready var ingredientSelection = $IngredientSelection
@onready var ingredientList = $IngredientSelection/HBoxContainer/MarginContainer/IngredientList
@onready var selectedIngredients: Array[ItemData]

@onready var itemDisplay:= $IngredientSelection/HBoxContainer/Grid/Item

@onready var mushroomData = preload("res://resources/items/mushroom.tres")
@onready var honeyData = preload("res://resources/items/honey.tres")
@onready var woodStickData = preload("res://resources/items/wood_stick.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	recipeList.append(mushroomData)
	recipeList.append(honeyData)
	recipeList.append(woodStickData)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_item_list_item_selected(index: int) -> void:
	recipeName.text = recipeList[index].name
	recipeIcon.texture = recipeList[index].icon
	recipeDesc.text = recipeList[index].description

func _on_item_list_item_activated(index: int) -> void:
	recipeSelection.hide()
	ingredientSelection.show()
	for item in InventoryManager.item_list:
		ingredientList.add_item(item.name, item.icon)

func _on_ingredient_list_item_selected(index: int) -> void:
	itemDisplay.fill_in_data(InventoryManager.item_list[index])
	itemDisplay.show()

func _on_ingredient_list_item_activated(index: int) -> void:
	selectedIngredients.append(InventoryManager.item_list[index])
	ingredientList.set_item_disabled(index, true)
	itemDisplay.hide()

func _on_button_button_down() -> void:
	var grid = $IngredientSelection/HBoxContainer/Grid
	grid.selectedItems = selectedIngredients
	var i = 0
	for item in grid.selectedItems:
		#grid.shapeList.append_array(item.shapes)
		grid.shapeDict[i] = item.shapes
		i += 1
	var ingredientListContainer = $IngredientSelection/HBoxContainer/MarginContainer
	ingredientListContainer.hide()
	var tilesContainer = $IngredientSelection/HBoxContainer/Grid/HBox/Tiles
	var shapeContainer = $IngredientSelection/HBoxContainer/Grid/HBox/Tiles/Shapes
	var max_shapes = 4
	for item: ItemData in grid.selectedItems:
		var new_image: TextureRect = TextureRect.new()
		new_image.texture = item.icon
		shapeContainer.add_child(new_image)
		for item_shape_id in range(max_shapes):
			var sampleChild: GridContainer = shapeContainer.get_child(0).duplicate()
			shapeContainer.add_child(sampleChild)
			var child_number = shapeContainer.get_child_count() - 1
			shapeContainer.get_child(child_number).show()
			if item_shape_id >= item.shapes.size():
				for item_tile: ColorRect in sampleChild.get_children():
					item_tile.color = Color.TRANSPARENT
				shapeContainer.add_child(sampleChild)
				continue
			var j = 0
			for item_tile: ColorRect in shapeContainer.get_child(child_number).get_children():
				if item.shapes[item_shape_id].shape[j]:
					item_tile.color = item.shapes[item_shape_id].get_color()
				j += 1
	tilesContainer.show()
	var button = $IngredientSelection/Button
	itemDisplay.hide()
	button.hide()
