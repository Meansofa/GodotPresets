extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", buy)

func buy():
	self.disabled = true
	Inventory.add_to_inventory(icon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
