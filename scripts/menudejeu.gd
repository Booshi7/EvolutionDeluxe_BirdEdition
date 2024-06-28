extends Node2D

var birds
var instantiatebird
var bestdist = 0
var disto = 0
var speed = 0
var hauteur = 0
var bestcam
var chrono = 0
var bestlist = []
var stats = [[[0,0,0,0,0], [0,0,0], [0]]]
var testcam

var invisible = false
var visibles = false
var multiple = false
var singlebird = false
var launchingmodevisible = false
var wanttoquit = false

var newfalaise
var neweau
var newbg
var newmesure
var newlinewater
var newdistbox

var gen :int = 0
var currentgen :int = 0
var totalbird :int = 100

var isboxshowing = [false, false, false]
var thethreebirds = []
var newbirdlistailejsp
var testdailenumber
var especelistnew

var quitting :int = 0
var oeilvisible = load("res://img/oeil.png")
var oeilinvisible = load("res://img/oeilbarré.png")

var maxtemps :int = 15*60
var membrechildcd :int
var membredroit :int
var membregauche :int
var birdchild
var addorremovemembre :int = 0

func _ready():
	Engine.max_fps = 60
	
	especelistnew = {}
	for i in range(1, 11):
		for j in range(1, 11):
			especelistnew[[i, j]] = 0
			
	var loadgame2 = FileAccess.open("birds.json", FileAccess.READ)
	var json_string2 = loadgame2.get_line()
	var json2 = JSON.new()
	var parse_resul2t = json2.parse(json_string2)
	var node_data2 = json2.get_data()
	birds = node_data2["birds"]
	
	var loadgame = FileAccess.open("stats.json", FileAccess.READ)
	var json_string = loadgame.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	var node_data = json.get_data()
	gen = node_data["gen"]
	stats = node_data["stats"]
	for j in range(1, gen+1):
		for i in stats[j][2].keys():
			stats[j][2][str_to_var(i)] = stats[j][2][i]
			stats[j][2].erase(i)
	totalbird = node_data["totalbird"]
	updategraphs()
	

func _process(delta):
	if invisible == true or visibles == true:
		chrono += 1
		#$time.text = 'Génération en cours...'
		$time2.text = "Gen " + str(gen) + " : " + str(chrono/(maxtemps/100)) + "%"
		if chrono%20 == 0:
			$roue.rotation_degrees += 45
		if chrono >= maxtemps:
			if chrono == maxtemps:
						killall()
						
						# gestion des espèces
						var especelist = especelistnew.duplicate()
						for i in $Everybirds.get_children():
							bestlist.append([i.distance, i.datas])
							especelist[i.especedata] += 1
							i.queue_free()
						var sortedespece = []
						for i in range(100):
							if especelist.values()[i] != 0:
								sortedespece.append([especelist.values()[i], especelist.keys()[i]])
						sortedespece.sort_custom(custsort)
						sortedespece = sortedespece.slice(0, 6)
						var espececountforbox = 0
						for i in especelist.keys():
							for j in sortedespece:
								if j[1] == i:
									j.append(round((250/float(totalbird))*float(espececountforbox+especelist[i]/2)))
							espececountforbox += especelist[i]
						
						# Gestion des stats
						bestlist.sort_custom(custsort)
						birds = []
						for i in bestlist:
							birds.append(i[1])
						stats.append([[roundten(bestlist[0][0]), roundten(bestlist[bestlist.size()-1][0]), roundten(bestlist[bestlist.size()/2 -1][0]),roundten(bestlist[(bestlist.size()/10)*9 -1][0]),roundten(bestlist[(bestlist.size()/10) -1][0])],
							[bestlist[0][1], bestlist[bestlist.size()-1][1], bestlist[bestlist.size()/2 -1][1]], especelist, sortedespece])
						
						# Reset
						chrono = 0
						bestlist = []
						
						
						
						if multiple == true:
							mutation()
							if wanttoquit:
								multiple = false
								wanttoquit = false
								$quitalafin.modulate = "FFFFFF"
								$quitalafin.visible = false
							else:
								#rerandomize()
								loadingallbirds()
								gen += 1
						if multiple == false:
							mutation()
							Engine.max_fps = 60
							if invisible == true:
								testcam.queue_free()
							if visibles == true:
								newfalaise.queue_free()
								newlinewater.queue_free()
								#newdistbox.queue_free()
							$Menuprinc.visible = true
							updategraphs()
							invisible = false
							visibles = false
							multiple = false
	
	# Switch de cam + distance max
	if visibles == true and chrono < maxtemps:
		bestdist = 0
		for i in $Everybirds.get_children():
			disto = round(i.distance*10)/10
			if disto > bestdist:
				bestdist = disto
				#hauteur = round(i.hauteurfinale*10)/10
				#speed = round(i.xspeed*10)/10
				bestcam = i.get_node("Camera2D")
				#newdistbox.global_position = bestcam.global_position
		if bestcam != null:
			bestcam.make_current()
			
				
				
	# Replay d'oiso
	if singlebird == true:
		chrono += 1
		bestdist = round($Everybirds/bird.distance*10)/10
		speed = round($Everybirds/bird.xspeed*10)/10
		hauteur = round($Everybirds/bird.hauteurfinale*10)/10
		newdistbox.global_position = $Everybirds/bird/Camera2D.global_position
		newdistbox.get_node("distancetext").text = str(bestdist)
		newdistbox.get_node("hauteurtext").text = str(hauteur)
		newdistbox.get_node("speedtext").text = str(speed)
		newdistbox.get_node("tempstext").text = str(floor(chrono/60))
		newdistbox.get_node("especetext").text = $Everybirds/bird.especename
		if chrono == maxtemps:
			newbg.findutemps()
			newdistbox.get_node("distancetext").label_settings.font_color = "FF0000"
			newdistbox.get_node("tempstext").label_settings.font_color = "FF0000"
		if Input.is_action_just_pressed("echap"):
			killall()
			$Everybirds/bird.queue_free()
			chrono = 0
			newfalaise.queue_free()
			newbg.queue_free()
			newmesure.queue_free()
			neweau.queue_free()
			newdistbox.queue_free()
			singlebird = false
			$Menuprinc.visible = true
			updategraphs(true)
	
	
	if Input.is_action_just_pressed("left"):
		rerandomize()
		
	#Click sur bird
	if visibles == false and invisible == false and singlebird == false and currentgen != 0:
		clickbirdreplay(0, 1)
		clickbirdreplay(1, 2)
		clickbirdreplay(2, 0)
		
	if quitting > 0:
		$time2.text = str(round(500-quitting)/5) + "%"
		if quitting%20 == 0:
			$roue.rotation_degrees += 45
		quitting -= 1
		if quitting == 1:
			get_tree().quit()


func _on_button_pressed():
	if launchingmodevisible == true:
		loadingallbirds(1)
		visibles = true
	else:
		testcam = Camera2D.new()
		add_child(testcam)
		testcam.position = Vector2(-10000, -10000)
		invisible = true
		loadingallbirds()
	multiple = false
	gen += 1
	
func _on_button_2_pressed():
	testcam = Camera2D.new()
	testcam.position = Vector2(-10000, -10000)
	add_child(testcam)
	loadingallbirds()
	invisible = true
	visibles = false
	multiple = true
	gen += 1
	$quitalafin.visible = true
	$quitalafin.grab_focus()
	
func _on_button_3_pressed():
	launchingmodevisible = !launchingmodevisible
	if launchingmodevisible == true: $Menuprinc/Button3.icon = oeilvisible
	else: $Menuprinc/Button3.icon = oeilinvisible
	
func custsort(a, b):
	if a[0]<b[0]:
		return false
	else:
		return true
		
func killall():
	for i in $Everybirds.get_children():
		i.dead = true
		
func loadingallbirds(truc = 0, datas = null):
	for i in $Menuprinc/graphiques.get_children():
		i.queue_free()
	
	if truc != 2:
		Engine.max_fps = 1000
		#var loadgame = FileAccess.open("birds.json", FileAccess.READ)
		#var json_string = loadgame.get_line()
		#var json = JSON.new()
		#var parse_result = json.parse(json_string)
		#var node_data = json.get_data()
		#birds = node_data["birds"]
		
		var loadbird = load("res://scene/bird.tscn")
		for i in birds:
			instantiatebird = loadbird.instantiate()
			$Everybirds.add_child(instantiatebird)
			instantiatebird.createbody(i)
			if truc == 1:
				var newcam = Camera2D.new()
				newcam.zoom = Vector2(0.2, 0.2)
				newcam.name = "Camera2D"
				instantiatebird.add_child(newcam)
			
	if truc == 1 or truc == 2:
		newfalaise = Sprite2D.new()
		newfalaise.texture = load("res://img/rocher.png")
		newfalaise.position = Vector2(533, 1555)
		newfalaise.scale = Vector2(5, 5)
		newfalaise.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		add_child(newfalaise)
		
		
		
		
		
		if truc == 1:
			newlinewater = Line2D.new()
			newlinewater.add_point(Vector2(0, 0))
			newlinewater.add_point(Vector2(100000, 0))
			newlinewater.default_color = "FFFFFF"
			newlinewater.width = 10
			newlinewater.position = Vector2(0, 3130)
			add_child(newlinewater)
		
		
	if truc == 2:
		Engine.max_fps = 60
		singlebird = true
		var loadbird = load("res://scene/bird.tscn")
		instantiatebird = loadbird.instantiate()
		$Everybirds.add_child(instantiatebird)
		instantiatebird.createbody(datas)
		instantiatebird.name = 'bird'
		
		var newcam = Camera2D.new()
		newcam.zoom = Vector2(0.8333, 0.8333)
		newcam.name = "Camera2D"
		instantiatebird.add_child(newcam)
		
		var loadbg = load("res://scene/background.tscn")
		var loadeau = load("res://scene/eau.tscn")
		var loadmesure = load("res://scene/mesure.tscn")
		neweau = loadeau.instantiate()
		newbg = loadbg.instantiate()
		newbg.bird = $Everybirds/bird
		newbg.z_index = -2
		newbg.scale = Vector2(2, 2)
		newmesure = loadmesure.instantiate()
		add_child(neweau)
		add_child(newbg)
		add_child(newmesure)
		
		newdistbox = Sprite2D.new()
		newdistbox.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		newdistbox.texture = load("res://img/Distance.png")
		newdistbox.name = "newdistbox"
		
		generatetext("la distance", 26, "000000", -5, -108, "distancetext", newdistbox)
		generatetext("la hateur", 26, "000000", -7, -54, "hauteurtext", newdistbox)
		generatetext("la speed", 26, "000000", -33, -82, "speedtext", newdistbox)
		generatetext("le temps", 45, "000000", -170, -30, "tempstext", newdistbox)
		generatetext("léspece", 26, "000000", -170, 20, "especetext", newdistbox)
		
		add_child(newdistbox)
		
		
	
	$Menuprinc.visible = false
	
func updategraphs(wassinglebirded = false):
	if wassinglebirded == false:
		currentgen = gen
	var maxmeter = stats[stats.size()-1][0][0]
	maxmeter = floor((maxmeter+10)/10)
	maxmeter *= 10
	var meters = []
	meters.append(maxmeter)
	meters.append(round(10*(3*float(maxmeter)/4))/10)
	meters.append(round(10*(2*float(maxmeter)/4))/10)
	meters.append(round(10*(float(maxmeter)/4))/10)
	#gen text
	
	
	#Graph
	generatebox(1000, 550, -1, 50, 200, "FFFFFF")
	
	#Espece
	generatebox(1000, 250, -1, 50, 780, "FFFFFF")
	
	#Bestoiso
	for i in range(3):
		generatebox(250, 250, -1, 1100+i*270, 290, "FFFFFF")
	
	
	#current gen box
	generatebox(790, 100, -1, 1100, 570, "FFFFFF")
	
	#0m line:
	var newline = Line2D.new()
	newline.add_point(Vector2(0, 0))
	newline.add_point(Vector2(1000, 0))
	newline.default_color = "000000"
	newline.width = 4
	newline.z_index = -1
	newline.position = Vector2(50, 720)
	$Menuprinc/graphiques.add_child(newline)
	
	#0m text
	var newtext = Label.new()
	newtext.text = "0m"
	newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	newtext.label_settings = LabelSettings.new()
	newtext.label_settings.font_size = 16
	newtext.label_settings.font_color = "000000"
	newtext.position.x = 52
	newtext.position.y = 722
	newtext.name = "zerom"
	$Menuprinc/graphiques.add_child(newtext)
	
	for i in range(4):
		newline = Line2D.new()
		newline.add_point(Vector2(0, 0))
		newline.add_point(Vector2(1000, 0))
		newline.default_color = "969696"
		newline.width = 2
		newline.z_index = -1
		newline.position = Vector2(50, 220+i*125)
		$Menuprinc/graphiques.add_child(newline)
		
		newtext = Label.new()
		newtext.text = str(meters[i])+"m"
		newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		newtext.label_settings = LabelSettings.new()
		newtext.label_settings.font_size = 14
		newtext.label_settings.font_color = "969696"
		newtext.position.x = 51
		newtext.position.y = 202+i*125
		newtext.name = "zerom"
		$Menuprinc/graphiques.add_child(newtext)
	
	generategraphicline(maxmeter, 0, 4, "00FF00")
	generategraphicline(maxmeter, 1, 4, "FF0000")
	generategraphicline(maxmeter, 2, 4, "0000FF")
	generategraphicline(maxmeter, 3, 1, "000000")
	generategraphicline(maxmeter, 4, 1, "000000")
	
	if gen > 0:
		generateespecegraph()
	#bestbird (endessou)
	#currentgen line:
	updatecurrentgenline()
	
	var newsliderclass = load("res://scene/slider.tscn")
	var newslider = newsliderclass.instantiate()
	$Menuprinc/graphiques.add_child(newslider)
	newslider.updateslider(currentgen, gen)
	
func updatecurrentgenline(): # gen line + birds
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
	if $Menuprinc/graphiques.get_node_or_null("currentgenthings") != null:
		$Menuprinc/graphiques.get_node("currentgenthings").queue_free()
	if $Menuprinc/graphiques.get_node_or_null("currentgenthings2") != null:
		$Menuprinc/graphiques.get_node("currentgenthings2").queue_free()
	var newnode = Node2D.new()
	var nameinutilecarcabug
	if $Menuprinc/graphiques.get_node_or_null("currentgenthings") != null:
		nameinutilecarcabug = "currentgenthings2"
		newnode.name = nameinutilecarcabug
	else:
		nameinutilecarcabug = "currentgenthings"
		newnode.name = nameinutilecarcabug
	$Menuprinc/graphiques.add_child(newnode)

	
	var newline = Line2D.new()
	newline.add_point(Vector2(0, 0))
	newline.add_point(Vector2(0, -830))
	newline.default_color = "00FFFF"
	newline.width = 4
	newline.z_index = 1
	newline.name = 'currentgenline'
	if gen == 0:
		newline.position = Vector2(round((1000/1)+50), 1030)
	else:
		newline.position = Vector2(round((1000/float(gen))*float(currentgen)+50), 1030)
	$Menuprinc/graphiques.get_node(nameinutilecarcabug).add_child(newline)
	
	# A REFAIRE LES 3 oiso !
	if currentgen != 0:
		thethreebirds = []
		var loadbird = load("res://scene/bird.tscn")
		instantiatebird = loadbird.instantiate()
		$Menuprinc/graphiques.get_node(nameinutilecarcabug).add_child(instantiatebird)
		instantiatebird.createbody(stats[currentgen][1][0], "photo")
		instantiatebird.position = Vector2(1765, 425)
		instantiatebird.scale = Vector2(1/float(instantiatebird.especedata.max()), 1/float(instantiatebird.especedata.max()))
		thethreebirds.append(instantiatebird)
		
		instantiatebird = loadbird.instantiate()
		$Menuprinc/graphiques.get_node(nameinutilecarcabug).add_child(instantiatebird)
		instantiatebird.createbody(stats[currentgen][1][2], "photo")
		instantiatebird.position = Vector2(1495, 425)
		instantiatebird.scale = Vector2(1/float(instantiatebird.especedata.max()), 1/float(instantiatebird.especedata.max()))
		thethreebirds.append(instantiatebird)
		
		instantiatebird = loadbird.instantiate()
		$Menuprinc/graphiques.get_node(nameinutilecarcabug).add_child(instantiatebird)
		instantiatebird.createbody(stats[currentgen][1][1], "photo")
		instantiatebird.position = Vector2(1225, 425)
		instantiatebird.scale = Vector2(1/float(instantiatebird.especedata.max()), 1/float(instantiatebird.especedata.max()))
		thethreebirds.append(instantiatebird)
		
		var espececountbestsix = stats[currentgen][3]
		for i in espececountbestsix:
			generatebox(150, 20, 2, round((1000/float(gen))*float(currentgen)+60), i[2]-10+780, "FFFFFF", $Menuprinc/graphiques.get_node(nameinutilecarcabug))
			var newtext = Label.new()
			newtext.text = namelist[i[1][0]][0] + namelist[i[1][1]][1] + " (C" + str(i[1][0]) + "D" + str(i[1][1]) + ") : " + str(i[0])
			newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			newtext.label_settings = LabelSettings.new()
			newtext.label_settings.font_size = 14
			newtext.label_settings.font_color = "000000"
			newtext.z_index = 3
			newtext.position.x = round((1000/float(gen))*float(currentgen)+61)
			newtext.position.y = i[2]-10+780
			$Menuprinc/graphiques.get_node(nameinutilecarcabug).add_child(newtext)
			
			
	#var newtext = Label.new()
	#newtext.text = "Génération " + str(gen)
	#newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#newtext.label_settings = LabelSettings.new()
	#newtext.label_settings.font_size = 36
	#newtext.label_settings.font_color = "FFFFFF"
	#newtext.position.x = 49
	#newtext.position.y = 54
	#newtext.name = "genlabel"
	#$Menuprinc/graphiques.add_child(newtext)
	generatetext("Génération " + str(currentgen) + '/' + str(gen), 50, 'FFFFFF', 350, 40, 'gentext', $Menuprinc/graphiques.get_node(nameinutilecarcabug))
	generatetext("Best distance = " + str(round(stats[currentgen][0][0]*10)/10) + 'm', 25, 'FFFFFF', 680, 130, 'bestdtext', $Menuprinc/graphiques.get_node(nameinutilecarcabug))
	generatetext("Median distance = " + str(round(stats[currentgen][0][2]*10)/10) + 'm', 25, 'FFFFFF', 630, 160, 'meddtext', $Menuprinc/graphiques.get_node(nameinutilecarcabug))

func generatebox(w, h, z, x, y, col, chemin = $Menuprinc/graphiques):
	var newpoly = Polygon2D.new()
	newpoly.set_polygon(PackedVector2Array([Vector2(0, 0),
			  Vector2(w, 0),
			  Vector2(w, h),
			  Vector2(0, h),
			]))
	
	newpoly.color = col
	newpoly.antialiased = true
	newpoly.z_index = z
	newpoly.position.x = x
	newpoly.position.y = y
	chemin.add_child(newpoly)

func generatetext(text, size, color, posx, posy, namee, path=$Menuprinc/graphiques):
	var newtext = Label.new()
	newtext.text = text
	#newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	newtext.label_settings = LabelSettings.new()
	newtext.label_settings.font_size = size
	newtext.label_settings.font_color = color
	newtext.label_settings.font = load("res://HoltwoodOneSC.ttf")
	newtext.position.x = posx
	newtext.position.y = posy
	newtext.name = namee
	path.add_child(newtext)

func generategraphicline(maxmeter, statsnumber, wid, col):
	var newline = Line2D.new()
	if gen != 0:
		for i in range(gen+1):
			newline.add_point(Vector2(round((1000/float(gen))*float(i)), round(stats[i][0][statsnumber]*-500/maxmeter)))
	else:
		newline.add_point(Vector2(0, 0))
		newline.add_point(Vector2(1000, 0))
	newline.default_color = col
	newline.width = wid
	newline.z_index = 1
	newline.position = Vector2(50, 720)
	$Menuprinc/graphiques.add_child(newline)

func generateespecegraph():
	var newnode = Node2D.new()
	var newpoly
	newnode.name = "especelines"
	$Menuprinc/graphiques.add_child(newnode)
	var totaldebirdpargen = []
	for i in range(gen+1):
		totaldebirdpargen.append(0)
	for i in especelistnew.keys():
		newpoly = Polygon2D.new()
		var newpackedvector = PackedVector2Array()
		newpackedvector.append(Vector2(0, 125))
		for j in range(1, gen+1):
			var nombredespece = stats[j][2][i]
			totaldebirdpargen[j] += nombredespece
			if j == gen:
				newpackedvector.append(Vector2(1000, round((250/float(totalbird))*float(totaldebirdpargen[j]))))
			else:
				newpackedvector.append(Vector2(round((1000/float(gen))*float(j)), round((250/float(totalbird))*float(totaldebirdpargen[j]))))
			
			
		newpackedvector.append(Vector2(1000, 0))
		newpackedvector.append(Vector2(round((1000/float(gen))), 0))
		
		newpoly.set_polygon(newpackedvector)
		newpoly.color = str(randi_range(100000, 1000000))
		newpoly.position.x = 50
		newpoly.position.y = 780
		$Menuprinc/graphiques.get_node("especelines").add_child(newpoly)
		$Menuprinc/graphiques.get_node("especelines").move_child(newpoly, 0)

func rerandomize():
	var newbird
	var birds = []
	for i in range(totalbird):
		newbird = [ [roundm(randf_range(-PI/6, PI/6)), roundm(randf_range(0.5, 1.5)), roundm(randf_range(0.02, 0.12)), roundm(randf_range(0.02, 0.12)), randi_range(0, 1),[]], [roundm(randf_range(PI/6 + PI - 2*PI/6, PI/6 + PI)), roundm(randf_range(0.5, 1.5)), roundm(randf_range(0.02, 0.12)), roundm(randf_range(0.02, 0.12)), randi_range(0, 1), []]]
		var testdaile
		for j in range(2):
			testdailenumber = 0
			testdaile = randomizeailenumber()
			newbirdlistailejsp = null
			if testdaile != null:
				newbird[j][5].append(testdaile)
		birds.append(newbird)
	var savedata = {
		"birds" = birds
	}
	var save_game = FileAccess.open("birds.json", FileAccess.WRITE)
	var json_string = JSON.stringify(savedata)
	save_game.store_line(json_string)
  
func randomizeailenumber():
	if randi_range(0, 1) == 1:
		testdailenumber += 1
		if testdailenumber < 10:
			var newnewaileforthebird = [roundm(randf_range(-PI/4, PI/4)), roundm(randf_range(0.5, 1.5)), roundm(randf_range(0.02, 0.12)),roundm(randf_range(0.02, 0.12)), roundm(randi_range(0, 1)),[]]
			if newbirdlistailejsp != null:
				newnewaileforthebird[5].append(newbirdlistailejsp)
			newbirdlistailejsp = newnewaileforthebird
			randomizeailenumber()
	return newbirdlistailejsp
	
func createinfobox(boxnumber, boxname):
	var newnode = Node2D.new()
	newnode.name = boxname
	newnode.z_index = 1
	$Menuprinc/graphiques.add_child(newnode)
	var newpoly = Polygon2D.new()
	newpoly.set_polygon(PackedVector2Array([Vector2(0, 0),
			  Vector2(250, 0),
			  Vector2(250, 100),
			  Vector2(0, 100),
			]))
	
	newpoly.color = Color(00, 00, 00, 20)
	newpoly.z_index = 1
	newpoly.position.x = 1100 + boxnumber * 270
	newpoly.position.y = 290+150
	$Menuprinc/graphiques.get_node(boxname).add_child(newpoly)
	
	var newtext = Label.new()
	if boxnumber == 0:
		newtext.text = str(round(stats[currentgen][0][1]*10)/10) + "m"
	if boxnumber == 1:
		newtext.text = str(round(stats[currentgen][0][2]*10)/10) + "m"
	if boxnumber == 2:
		newtext.text = str(round(stats[currentgen][0][0]*10)/10) + "m"
	newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	newtext.label_settings = LabelSettings.new()
	newtext.label_settings.font_size = 16
	newtext.label_settings.font_color = "FF0000"
	newtext.size = Vector2(250, 20)
	newtext.position.x = 1100 + boxnumber * 270
	newtext.position.y = 460
	newtext.z_index = 1
	$Menuprinc/graphiques.get_node(boxname).add_child(newtext)
	
	newtext = Label.new()
	if boxnumber == 0:
		newtext.text = thethreebirds[2].especename
	if boxnumber == 1:
		newtext.text = thethreebirds[1].especename
	if boxnumber == 2:
		newtext.text = thethreebirds[0].especename
	newtext.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	newtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	newtext.label_settings = LabelSettings.new()
	newtext.label_settings.font_size = 16
	newtext.label_settings.font_color = "00FFFF"
	newtext.size = Vector2(250, 20)
	newtext.position.x = 1100 + boxnumber * 270
	newtext.position.y = 490
	newtext.z_index = 1
	$Menuprinc/graphiques.get_node(boxname).add_child(newtext)

func updatecurrentgen(newcur):
	currentgen = newcur
	updatecurrentgenline()

func clickbirdreplay(boxnumber, birdnumber):
	if 1100 + 270*boxnumber <= get_global_mouse_position().x and get_global_mouse_position().x <= 1350 + 270*boxnumber and 300 <= get_global_mouse_position().y and  get_global_mouse_position().y <= 550 and $Menuprinc/graphiques.get_node("slider").issliding == false:
		if isboxshowing[boxnumber] == false:
			createinfobox(boxnumber, "infobox" + str(boxnumber))
			isboxshowing[boxnumber] = true
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) :
			isboxshowing[boxnumber] = false
			$Menuprinc/graphiques.get_node("infobox" + str(boxnumber)).queue_free()
			loadingallbirds(2, stats[currentgen][1][birdnumber])
	else:
		if $Menuprinc/graphiques.get_node_or_null("infobox" + str(boxnumber)) != null:
			$Menuprinc/graphiques.get_node("infobox" + str(boxnumber)).queue_free()
		isboxshowing[boxnumber] = false

func _on_quitalafin_pressed():
	wanttoquit = !wanttoquit
	if wanttoquit == true:
		$quitalafin.modulate = "00FF00"
	else: $quitalafin.modulate = "FFFFFF"


func roundten(d):
	return round(d*10)/10
func roundm(d):
	return round(d*1000)/1000


func _on_button_4_pressed():
	var newcamera = Camera2D.new()
	newcamera.position = Vector2(-10000, -10000)
	add_child(newcamera)
	$time.text = "Sauvegarde en cours..."
	var savedata = {
		"stats" = stats,
		"gen" = gen,
		"totalbird" = totalbird
	}
	var save_game = FileAccess.open("stats.json", FileAccess.WRITE)
	var json_string = JSON.stringify(savedata)
	save_game.store_line(json_string)
	
	var savedata2 = {
		"birds" = birds
	}
	var save_game2 = FileAccess.open("birds.json", FileAccess.WRITE)
	var json_string2 = JSON.stringify(savedata2)
	save_game2.store_line(json_string2)
	$Menuprinc/Label.text = "CA QUITTE DONC TOUCHEZ A RIEN"
	quitting = 500
	#mutation()






func mutation():
	var countdeletion = 0
	for i in range(totalbird-1, -1, -1):
		if randi_range(1, totalbird) < int(floor(totalbird*0.85)):
			birds.remove_at(i)
			countdeletion +=1
			if countdeletion == totalbird/2:
				break
	
	var coupledlist = []
	for penis in range(2):
		var minicoupled = []
		var newbirdlist = birds.duplicate()
		var randompick
		for i in range(totalbird/4):
			minicoupled.append([])
			for j in range(2):
				randompick = randi_range(0, newbirdlist.size()-1)
				minicoupled[i].append(newbirdlist[randompick])
				newbirdlist.remove_at(randompick)
		coupledlist.append_array(minicoupled)
		
	#var coupledlist = [[[[0.072, 1.004, 0.112, 0.082, 1, []], [2.773, 0.749, 0.052, 0.101, 0, [[-0.491, 1.286, 0.044, 0.051, 0, [[-0.709, 0.574, 0.103, 0.076, 1, []]]]]]],
	 #[[0.323, 1.436, 0.036, 0.106, 0, [[0.033, 0.62, 0.048, 0.062, 1, [[-0.444, 0.699, 0.023, 0.094, 0, [[0.257, 1.251, 0.071, 0.074, 1, []]]]]]]], [3.5, 1.45, 0.103, 0.119, 0, []]]]]
	#ici c'est un C3D1 et un C1D4
	#xD'abords on cherche la longueur de chaque aile de chaque parent
	#xPuis on séléction aléatoirement une longueur
	#xPuis for i in range longueur on ajoute un membre avec séléction aléatoire de chaque valeur
	#Ajouts de mutation
	#xPuis passe au membre suivant
	#xSi un des membre s'arrête, on prend que celui qui continue
	#xPuis à la fin on a une petite chance d'ajout de membre
	#xOn passe à l'autre bras
	
	for i in coupledlist:
		var loadbirde = load("res://scene/bird.tscn")
		var instantiatebirde = loadbirde.instantiate()
		$Everybirds.add_child(instantiatebirde)
		instantiatebirde.createbody(i[0])
		var membre_droit1 = instantiatebirde.especedata[0]
		var membre_gauche1 = instantiatebirde.especedata[1]
		
		#instantiatebirde = loadbirde.instantiate()
		instantiatebirde.createbody(i[1])
		var membre_droit2 = instantiatebirde.especedata[0]
		var membre_gauche2 = instantiatebirde.especedata[1]
		instantiatebirde.queue_free()
		if randi_range(0, 1) == 0:
			membredroit = membre_droit1
		else:
			membredroit = membre_droit2
		if randi_range(0, 1) == 0:
			membregauche = membre_gauche1
		else:
			membregauche = membre_gauche2
		birdchild = []
		membrechildcd = 0
		addorremovemembre = randi_range(0, 100)
		addchildmembre(birdchild,  [i[0][0]], [i[1][0]], membregauche)
		membrechildcd = 0
		addorremovemembre = randi_range(0, 100)
		addchildmembre(birdchild, [i[0][1]], [i[1][1]], membredroit, 1)
		birds.append(birdchild)
		

func addchildmembre(iteration, couple1, couple2, membre, dg = 0):
	if membrechildcd < membre:
		if membrechildcd == membre-1 and addorremovemembre < 5 and membre >1:
			pass
		else:
			iteration.append(randomizedstats(couple1, couple2, membrechildcd, dg))
			#[0, 0, 0, 0, 0, []]
			membrechildcd += 1
			if couple1 != []:
				#print("couple1 " + str(couple1))
				couple1 = couple1[0][5]
			if couple2 != []:
				#print("couple2 " + str(couple2))
				couple2 = couple2[0][5]
			addchildmembre(iteration[dg][5], couple1, couple2, membre)
	elif membrechildcd == membre:
		if addorremovemembre > 95 and membre < 10:
			iteration.append([roundm(randf_range(-PI/4, PI/4)), roundm(randf_range(0.5, 1.5)), roundm(randf_range(0.02, 0.10)),roundm(randf_range(0.02, 0.10)), roundm(randi_range(0, 1)),[]])
			membrechildcd += 1

func randomizedstats(c1, c2, cd, dg):
	var newwing = []
	var addrad
	if c1 == []: addrad = c2[0][0]
	elif c2 == []: addrad = c1[0][0]
	else:
		if randi_range(0, 1) == 1:
			addrad = c2[0][0]
		else:  addrad = c1[0][0]
	#addrad mutation
	var newmuta = (randf_range(-1, 1)**3)*0.2
	newmuta = addrad+newmuta
	newmuta = roundm(newmuta)
	if cd == 0:
		if dg == 0:
			if newmuta > PI/6:
				newmuta = PI/6
			if newmuta < -PI/6:
				newmuta = -PI/6
		else:
			if newmuta > PI/6 + PI:
				newmuta = PI/6 + PI
			if newmuta < PI/6 + PI - 2*PI/6:
				newmuta = PI/6 + PI - 2*PI/6
	else:
		if newmuta > PI/4:
			newmuta = PI/4
		if newmuta < -PI/4:
			newmuta = -PI/4
	newwing.append(newmuta)
	
	var addmaxampl
	if c1 == []: addmaxampl = c2[0][1]
	elif c2 == []: addmaxampl = c1[0][1]
	else:
		if randi_range(0, 1) == 1:
			addmaxampl = c2[0][1]
		else:  addmaxampl = c1[0][1]
	#addmaxampl mutation
	newmuta = (randf_range(-1, 1)**3)*0.2
	newmuta += addmaxampl
	newmuta = roundm(newmuta)
	if newmuta > 1.5:
		newmuta = 1.5
	if newmuta < 0.5:
		newmuta = 0.5
	newwing.append(newmuta)
	
	var addflex
	if c1 == []: addflex = c2[0][2]
	elif c2 == []: addflex = c1[0][2]
	else:
		if randi_range(0, 1) == 1:
			addflex = c2[0][2]
		else:  addflex = c1[0][2]
	#addflex mutation
	newmuta = (randf_range(-1, 1)**3)*0.03
	newmuta += addflex
	newmuta = roundm(newmuta)
	if newmuta > 0.10:
		newmuta = 0.10
	if newmuta < 0.02:
		newmuta = 0.02
	newwing.append(newmuta)
	
	var addext
	if c1 == []: addext = c2[0][3]
	elif c2 == []: addext = c1[0][3]
	else:
		if randi_range(0, 1) == 1:
			addext = c2[0][3]
		else:  addext = c1[0][3]
	#addext mutation
	newmuta = (randf_range(-1, 1)**3)*0.03
	newmuta += addext
	newmuta = roundm(newmuta)
	if newmuta > 0.10:
		newmuta = 0.10
	if newmuta < 0.02:
		newmuta = 0.02
	newwing.append(newmuta)
	
	var addfe
	if c1 == []: addfe = c2[0][4]
	elif c2 == []: addfe = c1[0][4]
	else:
		if randi_range(0, 1) == 1:
			addfe = c2[0][4]
		else:  addfe = c1[0][4]
	#addfe mutation
	if randi_range(0, 100) < 5:
		addfe = int(!bool(addfe))
	newwing.append(addfe)
	
	newwing.append([])
	return newwing
