class_name Vegetable
extends TextureButton

var type: int
var index: int
var parent: Grid
var highlighted: bool
var adjacent: PackedInt32Array = PackedInt32Array()


func _init() -> void:
	update_type(GameManager.get_new_type())
	highlighted = false


func _ready() -> void:
	index = get_index()
	parent = get_parent()


func update_type(new_type: int) -> void:
	type = new_type
	set_texture_normal(GameManager.SPRITES[type])
	set_texture_hover(GameManager.SPRITES_HIGHLIGHT[type])
	set_texture_focused(GameManager.SPRITES_SELECT[type])


func _on_pressed() -> void:
	match GameManager.current_state:

		GameManager.State.READY:
			_highlight_adjacent()
			GameManager.set_selected(self)

		GameManager.State.SELECTED:
			if highlighted:
				parent.try_swap(self)
				return

			parent.reset_grid()
			GameManager.set_ready()


func set_highlight(value: bool) -> void:
	highlighted = value


func _highlight_adjacent() -> void:
	for i in _get_adjacent():
		parent.get_vegetable(i).set_highlight(true)


func _get_adjacent() -> PackedInt32Array:
	if adjacent.size() > 0:
		return adjacent

	for offset: int in GameManager.offsets:
		var i: int = index + offset
		if _is_in_range(i):
			adjacent.append(i)

	return adjacent


func _is_in_range(i: int) -> bool:
	return 0 <= i and i < GameManager.GRID_SIZE ** 2
