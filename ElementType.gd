extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var etype
var etypeid
# Called when the node enters the scene tree for the first time.
func _ready():
	etype = self.name
	if etype == 'Fire':
		etypeid = 0
	elif etype == 'Water':
		etypeid = 1
	else:
		etypeid = 2
