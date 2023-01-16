extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SlotClass = preload("res://ElementType.gd")
onready var typeselect = get_node("NinePatchRect/CenterContainer/TextureRect")
var flashtext
var playerpanel
var TypeTextures
var timer = 0
var selected = ''
# Called when the node enters the scene tree for the first time.
func _ready():
	flashtext = get_node("EnterText")
	playerpanel = get_node("../P1Panel")
	flashtext.visible = false
	for type in typeselect.get_children():
		type.connect("gui_input",self,"select_input",[type])
	pass # Replace with function body.


func select_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			selected = slot.etype
			playerpanel.update_stats(null,slot.etypeid,-1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if selected != '' and timer > 0.5:
		flashtext.visible = !flashtext.visible
		timer = 0
	pass
