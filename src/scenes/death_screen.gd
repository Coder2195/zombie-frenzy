extends Control

# Called when the node enters the scene tree for the first time.
func load_stats():
  $Stats.text = "[center]Waves Survived: " + str(DataTracker.current_wave - 1) + "\nZombies Killed: " + str(DataTracker.zombies_killed) + "[/center]"

func restart():
  DataTracker.reset();
  get_tree().change_scene_to_file("res://scenes/game_scene.tscn");
