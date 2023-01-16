extends Popup


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var iname
var atklbl
var deflbl
var valid
var stats
# Called when the node enters the scene tree for the first time.
func _ready():
	iname = get_node("N/M/V/ItemName")
	stats = get_node("N/M/V/CenterContainer/Stats")
	valid = false
	
func init(itext,atk,def,hp):
	iname.set_text(itext)
	stats.get_node("FAtk/Label").text = "+" + str(atk[0])
	stats.get_node("WAtk/Label").text = "+" + str(atk[1])
	stats.get_node("GAtk/Label").text = "+" + str(atk[2])
	stats.get_node("FDef/Label").text = "+" + str(def[0])
	stats.get_node("WDef/Label").text = "+" + str(def[1])
	stats.get_node("GDef/Label").text = "+" + str(def[2])
	get_node("N/M/V/CenterContainer/CenterContainer/Health/Label").text = "+" + str(hp)
	valid = true
	#self.popup()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
