class_name Forcefield extends StaticBody2D;

static var scene: PackedScene = preload("res://sprites/game_scene/forcefield.tscn");


static func create() -> Forcefield:
  var this = scene.instantiate() as Forcefield;
  return this;

func _ready():
  $Animation.current_animation = "fade_out";
  $Animation.play();
  add_to_group("walls");


func delete(a):
  queue_free();
