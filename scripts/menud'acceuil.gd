extends Node2D
var birds = []
var newbird
var totalbird = 100
var testdailenumber
var newbirdlistailejsp
var framecount = 1
var newenter = false
var loadenter = false
var quitenter = false
var dgtext = false
var olddiv :int = 0


func _ready():
	Engine.max_fps = 60
	$AnimationPlayer.play("RESET")
	framecount = -0.016666*20
	olddiv = 0
	
func _process(delta):
	framecount += delta
	#print(floor(framecount/(27*0.01666)), olddiv, print)
	if floor(framecount/(26.7*0.01666)) != olddiv and floor(framecount/(27*0.01666)) > 0:
		
		olddiv += 1
		if framecount <= 23.485:
			$AnimationPlayer.play("new_animation")
		else:
			dgtext = !dgtext
			$AnimationPlayer.play("new_animation_2")
	if Input.is_action_just_pressed("down"):
		print(framecount)
	if framecount >= 23.605:
		$"colibri fou".rotation += PI/12
		$"faucon taré".rotation -= PI/20
		$"condor".rotation += PI/16
		#if dgtext == true:
			#$Start.position.y += 10*5
			#$Load.position.x -= 10*5
			#$quitter.position.x -= 13*5
			#$quitter.position.y += 8*5
		#if dgtext == false:
			#$Start.position.y -= 10*5
			#$Load.position.x += 10*5
			#$quitter.position.x += 13*5
			#$quitter.position.y -= 8*5
		
	if newenter == true:
		$Start.position.x -= 5
		if $Start.position.x <= 1487:
			$Start.position.x = 1487
				
	if newenter == false and $Start.position.x < 1587:
		$Start.position.x += 5
		
	if loadenter == true:
		$Load.position.x -= 5
		if $Load.position.x <= 1490:
			$Load.position.x = 1490
				
	if loadenter == false and $Load.position.x < 1590:
		$Load.position.x += 5
		
	if quitenter == true:
		$quitter.position.x -= 5
		if $quitter.position.x <= 1486:
			$quitter.position.x = 1486
				
	if quitenter == false and $quitter.position.x < 1586:
		$quitter.position.x += 5

func _on_start_pressed():
	rerandomize()
	var savedata = {
		"stats" = [[[0,0,0,0,0], [0,0,0], [0]]],
		"gen" = 0,
		"totalbird" = totalbird
	}
	var save_game = FileAccess.open("stats.json", FileAccess.WRITE)
	var json_string = JSON.stringify(savedata)
	save_game.store_line(json_string)
	get_tree().change_scene_to_file("res://scene/menudejeu.tscn")
	pass
			
func rerandomize():
	var newbird
	var birds = []
	for i in range(totalbird):
		newbird = [ [roundm(randf_range(-PI/6, PI/6)), roundm(randf_range(0.5, 1.5)), roundm(randf_range(0.02, 0.10)), roundm(randf_range(0.02, 0.10)), randi_range(0, 1),[]], [roundm(randf_range(PI/6 + PI - 2*PI/6, PI/6 + PI)), roundm(randf_range(0.5, 1.5)), roundm(randf_range(0.02, 0.12)), roundm(randf_range(0.02, 0.12)), randi_range(0, 1), []]]
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
			var newnewaileforthebird = [roundm(randf_range(-PI/4, PI/4)), roundm(randf_range(0.5, 1.5)), roundm(randf_range(0.02, 0.10)),roundm(randf_range(0.02, 0.10)), roundm(randi_range(0, 1)),[]]
			if newbirdlistailejsp != null:
				newnewaileforthebird[5].append(newbirdlistailejsp)
			newbirdlistailejsp = newnewaileforthebird
			randomizeailenumber()
	return newbirdlistailejsp
	


func _on_load_pressed():
	get_tree().change_scene_to_file("res://scene/menudejeu.tscn")


func _on_quitter_pressed():
	get_tree().quit()


func _on_start_mouse_entered():
	newenter = true


func _on_start_mouse_exited():
	newenter = false


func _on_load_mouse_entered():
	loadenter = true


func _on_load_mouse_exited():
	loadenter = false


func _on_quitter_mouse_entered():
	quitenter = true


func _on_quitter_mouse_exited():
	quitenter = false
	
func roundm(d):
	return round(d*1000)/1000
