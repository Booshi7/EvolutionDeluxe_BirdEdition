extends Node2D
@onready var body = $body

var rad = 0
var posx
var posy

var max_ampl = 2
var flexionspeed = 0.08
var retourspeed = 0.05
var isflexion = true
var flexioncd = 0

var gravity = 0
var xspeed = 20

var difference = 0 
var differencecount = 0
var differencecalcul = 0
var dead = false
var rotatecount = 0.0

var distance = 0
var hauteurfinale = 0

var datas = []

var photo
var especename
var especedata
var namelist = [
		["Em","eu"],
		["Coli","bri"],
		["Hi","bou"],
		["Caso","ar"],
		["Vau","tour"],
		["Fau", "con"],
		["Con","dor"],
		["Alba","tros"],
		["Pela","gornis"],
		["Tho","rondor"],
		["HoOhOoh","hAHa"],
	]
	


func _process(delta):
	if photo == null:
		if Input.is_action_pressed("down"):Engine.max_fps = 60
		if dead == false:
			#rotating()
			rotatecount = 0.0
			addingrotation(body, 0)
			difference = 0
			differencecount = 0
			calculerladifference(body, 0)
			difference = difference/differencecount
			differencecalcul = (-(difference/50)) + 3
			body.position.y += gravity/differencecalcul
			body.position.x += xspeed
			xspeed -= 0.03/differencecalcul
		#else:
			#get_tree().reload_current_scene()
		if xspeed < 0: xspeed = 0
		#if xspeed > 50: xspeed = 50
		if gravity < 50:
			gravity += 0.2
		else:
			gravity = 50
		#if gravity < -30: gravity = -30
		if body.position.y >= 10*313 or body.position.y <= -20*313:
			dead = true
			xspeed = 0
		if get_parent().get_parent().visibles == true or get_parent().get_parent().singlebird == true:
			if body.position.y <= 2657:
				$Camera2D.position = Vector2(body.position.x + 300, body.position.y)
			else:
				$Camera2D.position = Vector2(body.position.x + 300, 2657)
		if get_parent().get_parent().singlebird == true:
			get_parent().get_parent().get_node("background").position.x = body.position.x - 851
			get_parent().get_parent().get_node("background").paralax(xspeed, $Camera2D.position.y)
			get_parent().get_parent().get_node("Mesure").déplacement($Camera2D.position.x, $Camera2D.position.y)
			get_parent().get_parent().get_node("eau").waterupdate(body.position.x, xspeed, dead)
			get_parent().get_parent().get_node("newdistbox").position = Vector2($Camera2D.position.x -964, $Camera2D.position.y - 525)
		distance = body.position.x/450
		hauteurfinale = -body.position.y/313 + 10
		#$Control/CanvasLayer/fps.text = "yspeed = " + str(gravity/differencecalcul) + "   " + str(differencecalcul)+ "   " + str(gravity)
		#$Control/CanvasLayer/fps2.text = "xspeed = " + str(xspeed)
		#$Control/CanvasLayer/fps3.text = "distance = " + str(get_parent().get_parent().bestdist)
		#$Control/CanvasLayer/fps4.text = "hauteur = " + str(hauteurfinale)

func sinuscarré(x):
	var modulopi = fmod(abs(x),PI)
	if modulopi <= PI/2 :
		return (2/PI) * (modulopi)
	else:
		return (-2/PI) * (modulopi) + 2
		
func createbody(bodylist, phot = null):
	photo = phot
	if phot == 'photo':
		$Control.queue_free()
	especedata = [1,1]
	datas = bodylist
	createespece(datas[0])
	createespece(datas[1], 1)
	especename = namelist[especedata[0]][0] + namelist[especedata[1]][1] + " (C" + str(especedata[0]) + "D" + str(especedata[1]) + ")"
	$body/bodyimg.texture = load("res://img/tetes coupée.png")
	$body/bodyimg.hframes = 2
	$body/bodyimg.vframes = 10
	$body/bodyimg.frame = especedata[0]*2-2
	
	$body/bodyimg2.texture = load("res://img/tetes coupée.png")
	$body/bodyimg2.hframes = 2
	$body/bodyimg2.vframes = 10
	$body/bodyimg2.frame = especedata[1]*2-1
	
	for i in bodylist:
		var newaile = createaile(i, 0, 0, especedata[int(!bool(bodylist.find(i)))], int(!bool(bodylist.find(i))))
		body.add_child(newaile)

func createaile(ailelist, x, y, ailecolor, dg):
	var ailee = load("res://scene/aile.tscn")
	var aile = ailee.instantiate()
	aile.rad = ailelist[0]
	aile.max_ampl = ailelist[1]
	aile.flexionspeed = ailelist[2]
	aile.retourspeed = ailelist[3]
	aile.fex = ailelist[4]
	aile.creatingaile(x, y, ailecolor, dg)
	for j in ailelist[5]:
		var newnewaile = createaile(j, aile.posx, aile.posy, ailecolor, dg)
		aile.add_child(newnewaile)
	return aile
	
func createespece(bdata, gd = 0):
	for i in bdata[5]:
		if gd == 0:
			especedata[1] += 1
		elif gd == 1:
			especedata[0] += 1
		createespece(i, gd)

	
func calculerladifference(truc, oldrot):
	for i in truc.get_children():
		if "rad" in i:
			difference += abs(- sinuscarré(i.rotation- oldrot)*100)
			differencecount += 1
			calculerladifference(i, oldrot+i.rotation)
			
func addingrotation(truc, oldrot):
	for i in truc.get_children():
		if "rad" in i:
			var lollol = i.rotato(xspeed, gravity, rotatecount, oldrot)
			xspeed = lollol[0]
			gravity = lollol[1]
			rotatecount += 1.0
			addingrotation(i, oldrot + i.rotation)
			rotatecount -= 1.0
			
func updatebestdistbox():
	pass
