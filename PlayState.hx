package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;

class PlayState extends FlxState
{
	var playerspeed:Int = 200;
	var acceleration:Int = 300;
	var drag:Int = 200;
	var gravity:Int = 980;
	var jumpspeed:Int = -400;
	var player1:FlxSprite;
	var player2:FlxSprite;
	var background:FlxSprite;
	var ball:FlxSprite;
	var floor:FlxSprite;
	var leftwall:FlxSprite;
	var rightwall:FlxSprite;
	var goal1:FlxSprite;
	var goal2:FlxSprite;
	var score1:FlxText;
	var score2:FlxText;
	var result:FlxText;
	var p1score:Int = 0;
	var p2score:Int = 0;
	var runsound:FlxSound;
	var jumpsound:FlxSound;
	var kicksound:FlxSound;
	var goalsound:FlxSound;
	var gamewinsound:FlxSound;

	override public function create()
	{
		super.create();

		runsound = FlxG.sound.load(AssetPaths.running__wav);
		jumpsound = FlxG.sound.load(AssetPaths.jumppp22__wav);
		goalsound = FlxG.sound.load(AssetPaths.goalsound__wav);
		gamewinsound = FlxG.sound.load(AssetPaths.gamewin__wav);

		background = new FlxSprite(0,0);
		background.loadGraphic(AssetPaths.background__jpg);
		add(background);

		leftwall = new FlxSprite(0,0);
		leftwall.loadGraphic(AssetPaths.wall__png);
		leftwall.immovable=true;
		add(leftwall);

		goal1 = new FlxSprite(0,300);
		goal1.loadGraphic(AssetPaths.goal__png);
		goal1.immovable=true;
		add(goal1);

		rightwall = new FlxSprite(1070,0);
		rightwall.loadGraphic(AssetPaths.wall__png);
		rightwall.immovable=true;
		add(rightwall);

		goal2 = new FlxSprite(1040,300);
		goal2.loadGraphic(AssetPaths.goal2__png);
		goal2.immovable=true;
		add(goal2);

		ball = new FlxSprite(540,100);
        ball.loadGraphic(AssetPaths.ball2__png,true,40,30);
        ball.animation.add("ball",[0]);
        ball.animation.play("ball");
        ball.elasticity=0.5;
        add(ball);
        ball.drag.x = 100;
		ball.acceleration.y = this.gravity;

		floor = new FlxSprite(0,470);
		floor.loadGraphic(AssetPaths.floor__png);
		floor.immovable=true;
		add(floor);

		player1 = new FlxSprite(100,240);
		player1.loadGraphic(AssetPaths.p1run__png,true,150,191);
		player1.animation.add("Idle",[19]);
		player1.animation.add("RunRight", [0,1,2,3,4,5,6,7],8,true);
		player1.animation.add("RunLeft", [0,1,2,3,4,5,6,7],8,true,true);
		player1.animation.play("Idle");
		player1.immovable=false;
		add(player1);
		player1.drag.x = 400;
		player1.acceleration.y = this.gravity;

		score1 = new FlxText(100,50,""+p1score);
		score1.setFormat(30,FlxColor.RED);
		add(score1);

		player2 = new FlxSprite(850,240);
		player2.loadGraphic(AssetPaths.p1run__png,true,150,191);
		player2.animation.add("Idle",[19],true, true);
		player2.animation.add("RunRight", [0,1,2,3,4,5,6,7],8,true);
		player2.animation.add("RunLeft", [0,1,2,3,4,5,6,7],8,true,true);
		player2.animation.play("Idle");
		player2.immovable=false;
		add(player2);
		player2.drag.x = 400;
		player2.acceleration.y = this.gravity;

		score2 = new FlxText(980,50, ""+ p2score);
		score2.setFormat(30,FlxColor.BLUE);
		add(score2);

		result = new FlxText(440,50, " ");
		result.setFormat(30,FlxColor.BLACK);
		add(result);
	}	


	override public function update(elapsed:Float)
	{

		if (FlxG.keys.pressed.A) {
            player1.velocity.x = -playerspeed;
     		player1.animation.play("RunLeft");
     		runsound.play();
        } else if (FlxG.keys.pressed.D) {
            player1.velocity.x = playerspeed;
            player1.animation.play("RunRight");
            runsound.play();
        } else {
        	player1.acceleration.x = 0;
        	player1.animation.play("Idle");
        }
        if(FlxG.keys.pressed.W && player1.y > 250){
        	player1.velocity.y = this.jumpspeed;
        	jumpsound.play();
        }

        if (FlxG.keys.pressed.LEFT) {
            player2.velocity.x = -playerspeed;
            player2.animation.play("RunLeft");
            runsound.play();
        } else if (FlxG.keys.pressed.RIGHT) {
            player2.velocity.x = playerspeed;
            player2.animation.play("RunRight");
            runsound.play();
        } else {
        	player2.acceleration.x = 0;
        	player2.animation.play("Idle");
        }
        if(FlxG.keys.pressed.UP && player2.y > 250){
        	player2.velocity.y = this.jumpspeed;
        	jumpsound.play();
        }

        if(FlxG.collide(player1, ball)){
        	ball.velocity.y = -100 + FlxG.random.int(-250,0);
        	ball.velocity.x = 200;
        }
		if(FlxG.collide(player2, ball)){
        	ball.velocity.y = -100 + FlxG.random.int(-250,0);
        	ball.velocity.x = -200;
        }

        if (FlxG.collide(ball, goal2)){
        	remove(ball);
        	p1score++;
            resetBall();
            score1.text = "" + p1score;
            goalsound.play();
        }
        if (FlxG.collide(ball, goal1)){
        	remove(ball);
        	p2score++;
            resetBall();
            score2.text = "" + p2score;
            goalsound.play();
        }

        if (ball.y > 480){
        	resetBall();
        }

        if (p1score>4){
        	result.setFormat(30, FlxColor.BLACK);
        	result.text = "PLAYER 1 WINS!";
        	gamewinsound.play();
        	return;

        }
        if (p2score>4){
        	result.setFormat(30, FlxColor.BLACK);
        	result.text = "PLAYER 2 WINS!";
        	gamewinsound.play();
        	return;
        }
 
        super.update(elapsed);

        FlxG.collide(player1,floor);
        FlxG.collide(player2,floor);
        FlxG.collide(ball,floor);
        FlxG.collide(player1,ball);
        FlxG.collide(player2,ball);
        FlxG.collide(leftwall,player1);
        FlxG.collide(leftwall,player2);
        FlxG.collide(leftwall,ball);
        FlxG.collide(rightwall,player1);
        FlxG.collide(rightwall,player2);
        FlxG.collide(rightwall,ball);
	}

	public function resetBall(){
        add(ball);
        ball.x=540;
        ball.y=100;
    }
}
