extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
const BaseItem := preload("res://Item.tscn")
var itematk 
var itemdef 
var fireatk
var wateratk
var grassatk
var hpbonus
var slots
const SlotClass = preload("res://ShopSlot.gd")
# Called when the node enters the scene tree for the first time.
signal itemselect(item)

func _ready():
	self.itematk = ['Sword','Bow','Staff']
	self.itemdef = ['Shield','Plate','Gauntlets']
	self.fireatk = ['Dousing', 'Dampening', 'Moist', 'Waterfall']
	self.wateratk = ['Evaporation', 'Freezing', 'Boiling', 'Soaking', 'Sponge']
	self.grassatk = ['Burning', 'Incineration', 'Mowing', 'Flames']
	self.hpbonus = ['Fortitude', 'Stamina', 'Bravery','Endurance','Grit','Constitution']
	rng.randomize()
	self.slots = [get_node("Slot1"),get_node("Slot2"),get_node("Slot3")]
	for slot in slots:
		slot.get_node("ItemSlot").connect("gui_input",self,"select_input",[slot.get_node("ItemSlot")])


func select_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			emit_signal("itemselect", slot.slotitem)

func make_shop():
	for slot in slots:
		var genitem = generate()
		slot.get_node("ItemSlot").set_item(genitem)
		slot.init(genitem.itemname,genitem.atkbonus,genitem.defbonus,genitem.hpbonus)

func clean_shop():
	for slot in slots:
		slot.get_node("ItemSlot").remove_item()
	
func generate():
	var name = ''
	var firststat = rng.randi_range(0,5)
	var secondstat
	if firststat >= 3:
		if rng.randi_range(0,2) == 0:
			secondstat = 6
		else:
			secondstat = rng.randi_range(0,5)
	else:
		secondstat = rng.randi_range(0,5)
	if firststat < 3:
		name = self.itematk[rng.randi_range(0,len(self.itematk)-1)]
	else:
		name = self.itemdef[rng.randi_range(0,len(self.itemdef)-1)]
	var texture = "res://" + name + ".png"
	name += ' of '
	if secondstat == 6:
		name += self.hpbonus[rng.randi_range(0,len(self.hpbonus)-1)]
	elif secondstat%3 == 0:
		name += self.fireatk[rng.randi_range(0,len(self.fireatk)-1)]
	elif secondstat%3 == 1:
		name += self.wateratk[rng.randi_range(0,len(self.wateratk)-1)]
	else:
		name += self.grassatk[rng.randi_range(0,len(self.grassatk)-1)]
	var stats = [0,0,0,0,0,0,0]
	stats[firststat] += 1
	if secondstat == 6:
		stats[secondstat] += 2
	else:
		stats[secondstat] += 1
	var iatk = [stats[0],stats[1],stats[2]]
	var idef = [stats[3],stats[4],stats[5]]
	var newitem = BaseItem.instance()
	newitem.init(iatk,idef,name,texture,stats[6])
	return newitem

#func _process(delta):
#	pass
