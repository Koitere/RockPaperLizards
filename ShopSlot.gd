extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var slot_tex = preload("res://inventorytile.png")
var ItemBase = preload("res://Item.tscn")
var slotitem = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = slot_tex
	pass # Replace with function body.
	
func set_item(item):
	slotitem = item
	self.add_child(slotitem)

func remove_item():
	if slotitem != null:
		if slotitem.yielding == true:
			slotitem.cleanup = true
			slotitem = null
		else:
			slotitem.queue_free()
			slotitem = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
