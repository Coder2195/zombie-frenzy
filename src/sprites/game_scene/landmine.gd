class_name Landmine extends Area2D;

static var explosion_scene: PackedScene = preload("res://sprites/game_scene/explosion.tscn");

static func create() -> Landmine:
  var this = Landmine.new();
  return this;

func explode():
  var explosion = explosion_scene.instantiate();
  explosion.position = position;
  for body in $Blast.get_overlapping_bodies():
    var damage = global_position.distance_to(body.global_position) + 20;
    if body is Player:
      body.damage(damage / 2);
    elif body is Zombie:
      body.damage(damage);
    elif body is Vehicle:
      body.damage(damage / 4);

  get_node("/root/GameScene").add_child(explosion);
  queue_free();

func on_body_entered(_body):
  explode();
