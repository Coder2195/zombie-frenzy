class_name GameDataTracker extends Node2D;

var current_wave = 1;
var zombies_killed = 0;

func reset():
    current_wave = 1;
    zombies_killed = 0;