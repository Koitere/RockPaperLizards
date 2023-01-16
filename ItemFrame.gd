extends Control


var iname
var hp
var stats

func _ready():
	iname = get_node("ItemName")
	stats = get_node("CenterContainer/Stats")
	hp = get_node("CenterContainer/CenterContainer/Health/Label")
	
func init(itext,atk,def,nhp):
	iname.set_text(itext)
	stats.get_node("FAtk/Label").text = str(atk[0])
	stats.get_node("WAtk/Label").text = str(atk[1])
	stats.get_node("GAtk/Label").text = str(atk[2])
	stats.get_node("FDef/Label").text = str(def[0])
	stats.get_node("WDef/Label").text = str(def[1])
	stats.get_node("GDef/Label").text = str(def[2])
	self.hp.text = str(nhp)
