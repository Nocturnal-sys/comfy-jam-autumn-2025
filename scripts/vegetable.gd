class_name Vegetable
extends TextureButton

const OFFSETS: PackedInt32Array = [
	-1, 1, -GameManager.GRID_SIZE, GameManager.GRID_SIZE
]

var type: int
var index: int
var parent: Grid
var highlighted: bool
var adjacent: PackedInt32Array = []


func _init() -> void:
	type = GameManager.get_new_type()
	highlighted = false
	set_texture_normal(GameManager.SPRITES[type])


func _ready() -> void:
	index = get_index()
	parent = get_parent()


func _on_pressed() -> void:
	match GameManager.current_state:

		GameManager.State.READY:
			_highlight_adjacent()
			GameManager.set_selected(self)

		GameManager.State.SELECTED:
			if (highlighted and type != GameManager.selected_type):
				parent.try_swap(index, GameManager.selected_index)
				return

			parent.reset_grid()
			GameManager.set_ready()


func set_highlight(value: bool) -> void:
	highlighted = value


func _highlight_adjacent() -> void:
	for i in _get_adjacent():
		parent.get_vegetable(i).set_highlight(true)


func _get_adjacent() -> Array[int]:
	if adjacent.size() > 0:
		return adjacent

	for offset in OFFSETS:
		var i: int = index + offset
		if _is_in_range(i):
			adjacent.append(i)

	return adjacent


func _is_in_range(i: int) -> bool:
	return 0 <= i and i < GameManager.GRID_SIZE ** 2
