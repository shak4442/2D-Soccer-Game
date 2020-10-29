package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	//create variables to modify
	var start:FlxText;
	var play:FlxText;

	override public function create():Void
	{
		//text 1 for Main Menu
		start = new FlxText(360,40, "2D - SOCCER\n ", 45);
        add(start);
        //text 2 for Direction to start game
        play = new FlxText(50, 250, "      Player 1 Controls - A/D to move, W for Jump\nPlayer 2 Controls - LEFT/RIGHT to move, Up to Jump\n\n                             First to 5 wins!\n                         Press Space to Start!", 30);
        add(play);
        super.create();

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//function to start game after key is pressed
		if(FlxG.keys.anyPressed(["Space"]))
		{
        	FlxG.switchState(new PlayState());
        }
	}
}