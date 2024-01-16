package states;

import backend.WeekData;
import backend.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import tjson.TJSON as Json;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;


import lime.app.Application;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.group.FlxGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.gamepad.FlxGamepad;

import states.FlashState;
//import states.ComputerState;

class TitleScreenState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var madeLmao:Bool = false;

	var blackNothing:FlxSprite;
	var madeText:FlxText;
	var madeLogo:FlxSprite;
	var logo:FlxSprite;

	var coolMouse:FlxSprite = new FlxSprite().loadGraphic('assets/images/ItStealsCursor.png');


	override public function create()	
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];
		
		FlxG.save.data.curBorder = FlxG.random.int(1, 4);

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		Highscore.load();

		if (FlxG.save.data.showFlash == null)
			FlxG.save.data.showFlash = true;
		#if debug
			FlxG.save.data.showFlash = true;
		#end

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}
	
		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		if (initialized)
			startIntro();
		else
		{
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				startIntro();
			});
		}

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		
	}

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}
		blackNothing = new FlxSprite();
		blackNothing.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(blackNothing);


		madeText = new FlxText(240, 0, 300, 'MADE\nWITH', 75);
		madeText.antialiasing = ClientPrefs.data.antialiasing;
		madeText.alpha = 0;
		madeText.screenCenter(Y); 
		add(madeText);

		madeLogo = new FlxSprite(500, 0).loadGraphic(Paths.image('madewith'));
		madeLogo.antialiasing = ClientPrefs.data.antialiasing;
		madeLogo.scale.set(0.55, 0.55);
		madeLogo.updateHitbox();
		madeLogo.alpha = 0;
		madeLogo.screenCenter(Y);
		add(madeLogo);

		logo = new FlxSprite();
		logo.frames = Paths.getSparrowAtlas('modLogo');
		logo.animation.addByPrefix('idle', 'idle', 12, true);
		logo.animation.play('idle');
		logo.antialiasing = ClientPrefs.data.antialiasing;
		logo.screenCenter(XY);
		logo.alpha = 0;
		add(logo);

		madeLmao = true;
		FlxTween.tween(madeLogo, {alpha: 1.0}, 1, {
			startDelay: 0.2,
			ease: FlxEase.smootherStepIn,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(madeLogo, {alpha: 0.0}, 1, {
					startDelay: 2.5,
					ease: FlxEase.smootherStepOut,
					onComplete: function(twn:FlxTween)
                    {
						nextIntro();
						madeLmao = false;
						madeLogo.destroy();
						madeText.destroy();
					}
				});
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(madeLmao)
		{
			madeText.alpha = madeLogo.alpha;
		}
		
	}

	function nextIntro()
	{
		FlxTween.tween(logo, {alpha: 1.0}, 1, {
			ease: FlxEase.smootherStepIn,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(logo, {alpha: 0.0}, 1, {
					startDelay: 2.5,
					ease: FlxEase.smootherStepOut,
					onComplete: function(twn:FlxTween)
					{
						logo.destroy();
						if (FlxG.save.data.showFlash)
							LoadingState.loadAndSwitchState(new FlashState());
						else
							LoadingState.loadAndSwitchState(new ComputerState());
					}
				});
			}
		});
	}
}