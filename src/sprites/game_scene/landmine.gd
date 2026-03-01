class_name Landmine extends Area2D;

static var landmine_scene: PackedScene = preload("res://sprites/game_scene/landmine.tscn");
static var explosion_scene: PackedScene = preload("res://sprites/game_scene/explosion.tscn");


static func create() -> Landmine:
  var this = landmine_scene.instantiate() as Landmine;
  return this;


func explode(a):
  for body in $Blast.get_overlapping_bodies():
    var damage = max(120 - global_position.distance_to(body.global_position), 0);
    
    if body is Player:
      body.damage(damage / 2);
    elif body is Zombie:
      body.damage(damage);
    elif body is Vehicle:
      body.damage(damage / 4);
  
  var explosion = explosion_scene.instantiate();
  explosion.position = position;
  get_parent().add_child.call_deferred(explosion);
  queue_free();
