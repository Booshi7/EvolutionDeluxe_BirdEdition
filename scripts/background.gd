extends Node2D
var bird
#Pos du bg : -1153 -401

func _ready():
	nuagegeneration(50)
	nuagegeneration(550, 0, 100)
	nuagegeneration(1050)
	nuagegeneration(1550)
	nuagegeneration(300, -300, -50)
	nuagegeneration(800, -300, -50)
	nuagegeneration(1300, -300, -50)
	nuagegeneration(1800, -300, -50)
	#bird = get_parent().get_node("Everybirds").get_node("bird").get_node("Camera2D")	



func _process(delta):
	#position = Vector2(bird.position.x - 1000, bird.position.y - 1000)
	pass

func paralax(speed, positiony):
	if positiony <= 10000:
		position.y = positiony - 550 - positiony/10
		$TofuduskMoon.position.y = 255 + positiony/25
		$groupenuage.position.y = positiony/70
	
	$Montagnev2.position.x -= speed/10
	$Montagnev3.position.x -= speed/10
	if $Montagnev2.position.x <=-625 : $Montagnev2.position.x += 2480
	if $Montagnev3.position.x <=-625 : $Montagnev3.position.x += 2480
	
	$groupenuage.position.x -= speed/15
	if $groupenuage.position.x <= -450:
		$groupenuage.position.x += 500
		for i in $groupenuage.get_children():
			if i.position.x == 50:
				i.queue_free()
				nuagegeneration(1550)
			elif i.position.x == 300:
				i.queue_free()
				nuagegeneration(1800, -300, -50)
			else:
				i.position.x -= 500
		
	
	for i in $groupenuage.get_children():
		var nuagedecalage = $groupenuage.position.x + i.position.x
		i.get_children()[0].position.x = (nuagedecalage-500)/75
		


func nuagegeneration(xpos, miny = 0, maxy = 250):
	var newnuageblanc = Sprite2D.new()
	newnuageblanc.texture = load("res://img/nuagesblancs.png")
	newnuageblanc.hframes = 4
	newnuageblanc.vframes = 2
	var randimg = randi_range(0, 6)
	newnuageblanc.frame = randimg
	newnuageblanc.position = Vector2(xpos, randi_range(miny, maxy))
	newnuageblanc.z_index = -2
	newnuageblanc.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	newnuageblanc.scale = Vector2(2, 2)
	
	var newnuagenoir = Sprite2D.new()
	newnuagenoir.texture = load("res://img/nuagesnoirs.png")
	newnuagenoir.hframes = 4
	newnuagenoir.vframes = 2
	newnuagenoir.frame = randimg
	newnuagenoir.z_index = -1
	newnuagenoir.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	newnuagenoir.scale = Vector2(1.2, 1.2)
	
	var newnuageblanc2 = Sprite2D.new()
	newnuageblanc2.texture = load("res://img/nuagesblancs.png")
	newnuageblanc2.hframes = 4
	newnuageblanc2.vframes = 2
	newnuageblanc2.frame = randimg
	newnuageblanc2.z_index = 0
	newnuageblanc2.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	newnuageblanc2.scale = Vector2(1, -0.5)
	newnuageblanc2.position.y = -newnuageblanc.position.y*0.5 + 280 - newnuageblanc.position.y*0.35
	newnuageblanc2.modulate = "a7b38f"
	
	var newnuagenoir2 = Sprite2D.new()
	newnuagenoir2.texture = load("res://img/nuagesnoirs.png")
	newnuagenoir2.hframes = 4
	newnuagenoir2.vframes = 2
	newnuagenoir2.frame = randimg
	newnuagenoir2.z_index = 0
	newnuagenoir2.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	newnuagenoir2.scale = Vector2(1, -0.5)
	newnuagenoir2.position.y = -newnuageblanc.position.y*0.5/1.2 + 233 - newnuageblanc.position.y*0.35/1.2
	newnuagenoir2.modulate = "a7b38f"
	
	newnuagenoir.add_child(newnuagenoir2)
	newnuageblanc.add_child(newnuagenoir)
	newnuageblanc.add_child(newnuageblanc2)
	$groupenuage.add_child(newnuageblanc)
	
func findutemps():
	$vingtsec.visible = true
	
