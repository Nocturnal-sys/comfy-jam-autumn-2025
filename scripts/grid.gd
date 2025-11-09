extends CanvasLayer

@onready var grid_container: GridContainer = %GridContainer


func _ready() -> void:
	add_items()


func _process(_delta: float) -> void:
	pass


func add_items() -> void:
	for i in grid_container.get_columns():
		for j in grid_container.get_columns():
			var vegetable: Vegetable = Vegetable.new()
			grid_container.add_child(vegetable)
