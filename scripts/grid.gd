extends CanvasLayer

@onready var grid_container: GridContainer = %GridContainer

const GRID_SIZE: int = 8
var grid: Array[PackedInt32Array] = []


func _ready() -> void:
	grid_container.set_columns(GRID_SIZE)
	add_items()


func _process(_delta: float) -> void:
	pass


func add_items() -> void:
	for i in GRID_SIZE:
		grid.append(PackedInt32Array())
		for j in GRID_SIZE:
			var vegetable: Vegetable = Vegetable.new()
			grid[i].append(vegetable.type)
			grid_container.add_child(vegetable)
