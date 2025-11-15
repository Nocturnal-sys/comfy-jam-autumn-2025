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


func check_matches() -> void:
	var matches: Array[PackedVector2Array] = []

	for n in GRID_SIZE:
		matches.append_array(check_row(n))
		matches.append_array(check_column(n))

	set_matches(matches)


func check_row(i: int) -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []
	var match_group: PackedVector2Array = [Vector2i(i, 0)]

	for j in range(1, GRID_SIZE):
		if grid[i][j - 1] == grid[i][j]:
			match_group.append(Vector2i(i, j))
			continue

		if len(match_group) >= 3:
			matches.append(match_group)

		match_group.clear()
		match_group.append(Vector2i(i, j))

	return matches


func check_column(j: int) -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []
	var match_group: PackedVector2Array = [Vector2i(0, j)]

	for i in range(1, GRID_SIZE):
		if grid[i - 1][j] == grid[i][j]:
			match_group.append(Vector2i(i, j))
			continue

		if len(match_group) >= 3:
			matches.append(match_group)

		match_group.clear()
		match_group.append(Vector2i(i, j))

	return matches


func set_matches(matches: Array[PackedVector2Array]) -> void:
	for group: PackedVector2Array in matches:
		for item: Vector2i in group:
			set_match(item.x, item.y)


func set_match(i: int, j: int) -> void:
	var current: int = grid[i][j]
	grid[i][j] = current - 1 if current < 0 else -1
