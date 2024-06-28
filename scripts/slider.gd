extends Node2D
var posx
var issliding = false
var mousepos
var mouseclicked = false
var gene
var currentgene
var newtext

func _ready():
	pass


func _process(delta):
	if issliding == false:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if posx <= get_global_mouse_position().x and get_global_mouse_position().x <= posx+100 and 580 <= get_global_mouse_position().y and  get_global_mouse_position().y <= 680 and mouseclicked == false:
				issliding = true
				mousepos = get_global_mouse_position().x
			mouseclicked = true
		elif mouseclicked == true:
			mouseclicked = false
		
	if issliding == true:
		$Polygon2D.position.x = get_global_mouse_position().x - mousepos + posx
		if $Polygon2D.position.x > 1790: $Polygon2D.position.x = 1790
		if $Polygon2D.position.x < 1100: $Polygon2D.position.x = 1100
		newtext.position.x = $Polygon2D.position.x
		var newcurrentgen = floor(($Polygon2D.position.x-1100)/(690/float(gene)))
		if newcurrentgen != currentgene:
			currentgene = newcurrentgen
			newtext.text = str(currentgene)
			get_parent().get_parent().get_parent().updatecurrentgen(currentgene)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == false:
			issliding = false
			mouseclicked = false
			posx = $Polygon2D.position.x

func updateslider(currentgen, gen):
	$Polygon2D.set_polygon(PackedVector2Array([Vector2(0, 0),
			  Vector2(100, 0),
			  Vector2(100, 100),
			  Vector2(0, 100),
			]))
	
	$Polygon2D.color = "707070"
	$Polygon2D.z_index = 1
	posx = round((690/float(gen))*float(currentgen))+1100
	$Polygon2D.position.x = posx
	$Polygon2D.position.y = 570
	newtext = Label.new()
	newtext.text = str(currentgen)
	newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	newtext.label_settings = LabelSettings.new()
	newtext.label_settings.font = load("res://HoltwoodOneSC.ttf")
	newtext.label_settings.font_size = 32
	newtext.label_settings.font_color = "FFFFFF"
	newtext.z_index = 1
	newtext.size = Vector2(100, 100)
	newtext.position.x = posx
	newtext.position.y = 570
	add_child(newtext)
	gene = gen
	currentgene = currentgen
