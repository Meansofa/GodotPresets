extends Button


@export var cost : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", buy)

func buy():
	if Inventory.coins < cost:
		print(self.name, ", Insufficient Funds Money: ", Inventory.coins, " , cost: ", cost)
		return
	self.disabled = true
	Inventory.add_to_inventory(icon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
