extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var restext
var animation
var coinfliptex
var p1type
var p2type
var compare
var compare2
var p1stats
var p2stats
var fire_text = preload("res://fire.png")
var water_text = preload("res://water.png")
var grass_text = preload("res://grass.png")
var fireatk = preload("res://fireatk.png")
var firedef = preload("res://firedef.png")
var wateratk = preload("res://wateratk.png")
var waterdef = preload("res://waterdef.png")
var grassatk = preload("res://grassatk.png")
var grassdef = preload("res://grassdef.png")
var typetexts
var typeatk
var typedef
# Called when the node enters the scene tree for the first time.
func _ready():
	restext = get_node("DRAW")
	animation = get_node("AnimationPlayer")
	coinfliptex = get_node("coinflip")
	p1type = get_node("CompareControl/P1Type")
	p2type = get_node("CompareControl/P2Type")
	compare = get_node("CompareControl/Compare")
	compare2 = get_node("CompareControl/Compare2")
	p1stats = get_node("CompareControl/P1Stats")
	p2stats = get_node("CompareControl/P2Stats")
	typetexts = [fire_text,water_text,grass_text]
	typeatk = [fireatk,wateratk,grassatk]
	typedef = [firedef,waterdef,grassdef]

func resolve_draw(player1,player2,lives):
	var pwin
	player1.get_node("AnimationPlayer/Player").visible = false
	player2.get_node("AnimationPlayer/Player").visible = false
	restext.text = "DRAW!"
	animation.play("DrawStart")
	p1stats.get_node("P1Combine/Def/Label").text = str((player1.attack[player2.type] + player1.defence[player2.type]))
	p2stats.get_node("P2Combine/Def/Label").text  = str((player2.attack[player1.type] + player2.defence[player1.type]))
	yield(animation, "animation_finished")
	if player1.type == 0:
		if player2.type == 2:
			pwin = true
			yield(type_adv(player1,player2, '>'), "completed")
			restext.text = player1.pname + " wins!"
		elif player2.type == 1:
			yield(type_adv(player1,player2,'<'), "completed")
			lives -= 1
			restext.text = player2.pname + " wins!"
		else:
			if (player1.attack[player2.type] + player1.defence[player2.type]) > (player2.attack[player1.type] + player2.defence[player1.type]):
				pwin = true
				yield(type_same(player1,player2,'>'), "completed")
				restext.text = player1.pname + " wins!"
			elif (player1.attack[player2.type] + player1.defence[player2.type]) < (player2.attack[player1.type] + player2.defence[player1.type]):
				yield(type_same(player1,player2,'<'), "completed")
				lives -= 1
				restext.text = player2.pname + " wins!"
			elif (player1.attack[player2.type] + player1.defence[player2.type]) == (player2.attack[player1.type] + player2.defence[player1.type]):
				yield(type_same(player1,player2,'='), "completed")
				pwin = yield(coinflip(player1,player2),"completed")
				if pwin == false:
					lives -= 1
	elif player1.type == 1:
		if player2.type == 0:
			pwin = true
			yield(type_adv(player1,player2,'>'), "completed")
			restext.text = player1.pname + " wins!"
		elif player2.type == 2:
			yield(type_adv(player1,player2,'<'), "completed")
			restext.text = player2.pname + " wins!"
			lives -= 1
		else:
			if (player1.attack[player2.type] + player1.defence[player2.type]) > (player2.attack[player1.type] + player2.defence[player1.type]):
				pwin = true
				yield(type_same(player1,player2,'>'), "completed")
				restext.text = player1.pname + " wins!"
			elif (player1.attack[player2.type] + player1.defence[player2.type]) < (player2.attack[player1.type] + player2.defence[player1.type]):
				yield(type_same(player1,player2,'<'), "completed")
				lives -= 1
				restext.text = player2.pname + " wins!"
			elif (player1.attack[player2.type] + player1.defence[player2.type]) == (player2.attack[player1.type] + player2.defence[player1.type]):
				yield(type_same(player1,player2,'='), "completed")
				pwin = yield(coinflip(player1,player2),"completed")
				if pwin == false:
					lives -= 1
	elif player1.type == 2:
		if player2.type == 1:
			yield(type_adv(player1,player2,'>'), "completed")
			pwin = true
			restext.text = player1.pname + " wins!"
		elif player2.type == 0:
			yield(type_adv(player1,player2,'<'), "completed")
			lives -= 1
			restext.text = player2.pname + " wins!"
		else:
			if (player1.attack[player2.type] + player1.defence[player2.type]) > (player2.attack[player1.type] + player2.defence[player1.type]):
				pwin = true
				yield(type_same(player1,player2,'>'), "completed")
				restext.text = player1.pname + " wins!"
			elif (player1.attack[player2.type] + player1.defence[player2.type]) < (player2.attack[player1.type] + player2.defence[player1.type]):
				yield(type_same(player1,player2,'<'), "completed")
				lives -= 1
				restext.text = player2.pname + " wins!"
			elif (player1.attack[player2.type] + player1.defence[player2.type]) == (player2.attack[player1.type] + player2.defence[player1.type]):
				yield(type_same(player1,player2,'='), "completed")
				pwin = yield(coinflip(player1,player2),"completed")
				if pwin == false:
					lives -= 1
	return [pwin,lives]
func type_adv(p1,p2,comp):
	p1type.texture = typetexts[p1.type]
	p2type.texture = typetexts[p2.type]
	compare.text = comp
	restext.text = "Type Battle!"
	animation.play("ElementCompare")
	yield(animation,"animation_finished")

func type_same(p1,p2,comp):
	yield(type_adv(p1,p2,'='), "completed")
	restext.text = "Stats Battle!"
	compare2.text = comp
	p1stats.get_node("P1Seperate/Atk/Icon").texture = typeatk[p1.type]
	p1stats.get_node("P1Seperate/Def/Icon").texture = typedef[p1.type]
	p1stats.get_node("P1Combine/Atk/Icon").texture = typeatk[p1.type]
	p1stats.get_node("P1Combine/Def/Icon").texture = typedef[p1.type]
	p2stats.get_node("P2Seperate/Atk/Icon").texture = typeatk[p2.type]
	p2stats.get_node("P2Seperate/Def/Icon").texture = typedef[p2.type]
	p2stats.get_node("P2Combine/Atk/Icon").texture = typeatk[p2.type]
	p2stats.get_node("P2Combine/Def/Icon").texture = typedef[p2.type]
	animation.play("StatsMove")
	yield(animation, "animation_finished")
	
func coinflip(p1,p2):
	restext.text = "Coinflip!"
	get_node("CompareControl").visible = false
	animation.play("Coinflip")
	yield(animation,"animation_finished")
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randi_range(0,1) == 0:
		coinfliptex.play("p1win")
		yield(coinfliptex, "animation_finished")
		restext.text = p1.pname + " wins!"
		return true
	else:
		coinfliptex.play("p2win")
		yield(coinfliptex, "animation_finished")
		restext.text = p2.pname + " wins!"
		return false
