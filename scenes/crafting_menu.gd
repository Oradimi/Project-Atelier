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
	for item in InventoryData.itemList:
		ingredientList.add_item(item.name, item.icon)

func _on_ingredient_list_item_selected(index: int) -> void:
	itemDisplay.fill_in_data(InventoryData.itemList[index])
	itemDisplay.show()

func _on_ingredient_list_item_activated(index: int) -> void:
	selectedIngredients.append(InventoryData.itemList[index])
	ingredientList.set_item_disabled(index, true)
	itemDisplay.hide()

func _on_button_button_down() -> void:
	var grid = $IngredientSelection/HBoxContainer/Grid
	grid.selectedItems = selectedIngredients
	for item in grid.selectedItems:
		grid.shapeList.append_array(item.shapes)
	var ingredientListContainer = $IngredientSelection/HBoxContainer/MarginContainer
	ingredientListContainer.hide()
	var tilesContainer = $IngredientSelection/HBoxContainer/Grid/HBox/Tiles
	var shapeContainer = $IngredientSelection/HBoxContainer/Grid/HBox/Tiles/Shapes
	for item: ItemData in grid.selectedItems:
		#shapeContainer.add_icon_item(item.icon, false)
		for item_shape: ShapeData in item.shapes:
			var sampleChild = shapeContainer.get_child(0).duplicate()
			shapeContainer.add_child(sampleChild)
			var child_number = shapeContainer.get_child_count() - 1
			shapeContainer.get_child(child_number).show()
			var j = 0
			for item_tile: ColorRect in shapeContainer.get_child(child_number).get_children():
				if (item_shape.shape[j]):
					item_tile.color = item_shape.get_color()
				j += 1
	tilesContainer.show()
	var button = $IngredientSelection/Button
	itemDisplay.hide()
	button.hide()
