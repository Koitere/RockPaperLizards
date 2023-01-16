extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fireatk
var firedef
var wateratk
var waterdef
var grassatk
var grassdef
var basehp
var playername
var typeicon
var fire_text = preload("res://fire.png")
var water_text = preload("res://water.png")
var grass_text = preload("res://grass.png")
var base_text = preload("res://ElementPlaceholder.png")
var TypeTextures
# Called when the node enters the scene tree for the first time.
func _ready():
	fireatk = get_node("StatPanel/Stats/FAtk/FAtk/Label")
	firedef = get_node("StatPanel/Stats/FDef/FDef/Label")
	wateratk = get_node("StatPanel/Stats/WAtk/WAtk/Label")
	waterdef = get_node("StatPanel/Stats/WDef/WDef/Label")
	grassatk = get_node("StatPanel/Stats/GAtk/GAtk/Label")
	grassdef = get_node("StatPanel/Stats/GDef/GDef/Label")
	basehp = get_node("StatPanel/Health/Label")
	playername = get_node("VBoxContainer/Label")
	typeicon = get_node("VBoxContainer/TextureRect")
	TypeTextures = [fire_text,water_text,grass_text]


func update_stats(player, icon, p2type):
	if player != null:
		fireatk.text = str(player.attack[0])
		wateratk.text = str(player.attack[1])
		grassatk.text = str(player.attack[2])
		firedef.text = str(player.defence[0])
		waterdef.text = str(player.defence[1])
		grassdef.text = str(player.defence[2])
		basehp.text = str(player.hp)
		playername.text = player.pname
	typeicon.texture = TypeTextures[icon]
	if player == null:
		if icon == 0:
			fireatk.text = '0'
			wateratk.text = '0'
			grassatk.text = '1'
			firedef.text = '0'
			waterdef.text = '-1'
			grassdef.text = '1'
		elif icon == 1:
			fireatk.text = '1'
			wateratk.text = '0'
			grassatk.text = '0'
			firedef.text = '1'
			waterdef.text = '0'
			grassdef.text = '-1'
		else:
			fireatk.text = '0'
			wateratk.text = '1'
			grassatk.text = '0'
			firedef.text = '-1'
			waterdef.text = '1'
			grassdef.text = '0'
		basehp.text = str(10)
		playername.text = 'Player'
	var highlight
	match p2type:
		-1:
			highlight = [false,false,false,false,false,false]
		0:
			highlight = [true,true,false,false,false,false]
		1:
			highlight = [false,false,true,true,false,false]
		2:
			highlight = [false,false,false,false,true,true]
	get_node("StatPanel/Stats/FAtk/ColorRect").visible = highlight[0]
	get_node("StatPanel/Stats/FDef/ColorRect").visible = highlight[1]
	get_node("StatPanel/Stats/WAtk/ColorRect").visible = highlight[2]
	get_node("StatPanel/Stats/WDef/ColorRect").visible = highlight[3]
	get_node("StatPanel/Stats/GAtk/ColorRect").visible = highlight[4]
	get_node("StatPanel/Stats/GDef/ColorRect").visible = highlight[5]
		
func clear_panel():
	fireatk.text = str(0)
	wateratk.text = str(0)
	grassatk.text = str(0)
	firedef.text = str(0)
	waterdef.text = str(0)
	grassdef.text = str(0)
	basehp.text = str(10)
	playername.text = "Opponent"
	typeicon.texture = base_text
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
