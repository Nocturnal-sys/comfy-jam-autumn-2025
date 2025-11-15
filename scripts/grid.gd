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


func _update_items() -> void:
	for i in GRID_SIZE:
		for j in GRID_SIZE:
			var index: int = i * GRID_SIZE + j
			var vegetable: Vegetable = grid_container.get_child(index)
			vegetable.type = grid[i][j]


func check_matches() -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []

	for n in GRID_SIZE:
		matches.append_array(_check_row(n))
		matches.append_array(_check_column(n))

	return matches


func _check_row(i: int) -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []
	var match_group: PackedVector2Array = [Vector2i(i, 0)]

	for j in range(1, GRID_SIZE):
		if grid[i][j - 1] == grid[i][j]:
			match_group.append(Vector2i(i, j))
			continue

		if match_group.size() >= 3:
			matches.append(match_group)

		match_group.clear()
		match_group.append(Vector2i(i, j))

	return matches


func _check_column(j: int) -> Array[PackedVector2Array]:
	var matches: Array[PackedVector2Array] = []
	var match_group: PackedVector2Array = [Vector2i(0, j)]

	for i in range(1, GRID_SIZE):
		if grid[i - 1][j] == grid[i][j]:
			match_group.append(Vector2i(i, j))
			continue

		if match_group.size() >= 3:
			matches.append(match_group)

		match_group.clear()
		match_group.append(Vector2i(i, j))

	return matches


func set_matches(matches: Array[PackedVector2Array]) -> void:
	for group: PackedVector2Array in matches:
		for item: Vector2i in group:
			_set_match(item.x, item.y)


func _set_match(i: int, j: int) -> void:
	var current: int = grid[i][j]
	grid[i][j] = current - 1 if current < 0 else -1


func update_grid() -> void:
	for n in GRID_SIZE:
		_update_column(n)

	_update_items()


func _update_column(j: int) -> void:
	var count: int = 0

	for i in range(GRID_SIZE - 1, -1, -1):
		if grid[i][j] < 0:
			count += 1
		elif count > 0:
			grid[i + count][j] = grid[i][j]

	for i in count:
		grid[i][j] = GameManager.get_new_type()
