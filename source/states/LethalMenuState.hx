package states;

import lime.app.Application;
import lime.ui.Window;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.group.FlxGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxGradient;

import states.MiniOptionState;
//import states.WowFreeplayState;
//import substates.ItsStoryModeSubstate;
import options.OptionsState;

class LethalMenuState extends MusicBeatState
{
    var yoooBg:FlxSprite;

    var menuLogo:FlxSprite;

    var story:FlxText;
    var storyBack:FlxSprite;
    var freeplay:FlxText;
    var freeplayBack:FlxSprite;
    var settings:FlxText;
    var settingsBack:FlxSprite;
    var credits:FlxText;
    var creditsBack:FlxSprite;
    var quit:FlxText;
    var quitBack:FlxSprite;

    var currentSelKeys:Int = 0;
    var currentSelMouse:Int = -1;

    var scaleAtX:Float = 0.001;
    var scaleAtY:Float = 0.001;

    var changeScale:Bool = true;

    var windowsDeath:Bool = false;
    
    var vers:FlxText;
    var cornorShit:FlxSprite;

    var vinn:FlxSprite;

    var coolMouse:FlxSprite;
    var menuThing:FlxTween;

    override function create()
    {

        coolMouse = new FlxSprite(0, 0).loadGraphic(Paths.image('ItStealsCursor'));
        coolMouse.antialiasing = ClientPrefs.data.antialiasing;
        coolMouse.scale.set(0.8, 0.8);

        yoooBg = new FlxSprite();
		yoooBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        yoooBg = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF0C0000, 0xFF000000], 2);
		add(yoooBg);

        menuLogo = new FlxSprite(0, 30).loadGraphic(Paths.image('logo'));
        menuLogo.screenCenter(X);
        menuLogo.antialiasing = ClientPrefs.data.antialiasing;
        add(menuLogo);

        story = new FlxText(50, 0, 450, "> Story Mode", 30);
        story.font = Paths.font('3270-Regular.ttf');
        story.color = 0xFF000000; //0xFFe55b22;
        story.screenCenter(Y);
        story.antialiasing = ClientPrefs.data.antialiasing;

        storyBack = new FlxSprite(story.x - 5, story.y - 5).makeGraphic(Math.floor(story.width+5), Math.floor(story.height +5), 0xFFff4100);
        storyBack.antialiasing = ClientPrefs.data.antialiasing;
        storyBack.alpha = 1; //0

        add(storyBack);
        add(story);

        freeplay = new FlxText(50, 0, 450, "> Freeplay", 30);
        freeplay.font = Paths.font('3270-Regular.ttf');
        freeplay.color = 0xFFe55b22;
        freeplay.screenCenter(Y);
        freeplay.y += story.height * 2;
        freeplay.antialiasing = ClientPrefs.data.antialiasing;

        freeplayBack = new FlxSprite(freeplay.x - 5, freeplay.y - 5).makeGraphic(Math.floor(freeplay.width+5), Math.floor(freeplay.height +5), 0xFFff4100);
        freeplayBack.antialiasing = ClientPrefs.data.antialiasing;
        freeplayBack.alpha = 0;

        add(freeplayBack);
        add(freeplay);

        settings = new FlxText(50, 0, 450, "> Settings", 30);
        settings.font = Paths.font('3270-Regular.ttf');
        settings.color = 0xFFe55b22;
        settings.screenCenter(Y);
        settings.y += story.height * 4;
        settings.antialiasing = ClientPrefs.data.antialiasing;

        settingsBack = new FlxSprite(settings.x - 5, settings.y - 5).makeGraphic(Math.floor(settings.width+5), Math.floor(settings.height +5), 0xFFff4100);
        settingsBack.antialiasing = ClientPrefs.data.antialiasing;
        settingsBack.alpha = 0;

        add(settingsBack);
        add(settings);

        credits = new FlxText(50, 0, 450, "> Credits", 30);
        credits.font = Paths.font('3270-Regular.ttf');
        credits.color = 0xFFe55b22;
        credits.screenCenter(Y);
        credits.y += story.height * 6;
        credits.antialiasing = ClientPrefs.data.antialiasing;

        creditsBack = new FlxSprite(credits.x - 5, credits.y - 5).makeGraphic(Math.floor(credits.width+5), Math.floor(credits.height +5), 0xFFff4100);
        creditsBack.antialiasing = ClientPrefs.data.antialiasing;
        creditsBack.alpha = 0;

        add(creditsBack);
        add(credits);

        quit = new FlxText(50, 0, 450, "> Quit", 30);
        quit.font = Paths.font('3270-Regular.ttf');
        quit.color = 0xFFe55b22;
        quit.screenCenter(Y);
        quit.y += story.height * 8;
        quit.antialiasing = ClientPrefs.data.antialiasing;

        quitBack = new FlxSprite(quit.x - 5, quit.y - 5).makeGraphic(Math.floor(quit.width+5), Math.floor(quit.height +5), 0xFFff4100);
        quitBack.antialiasing = ClientPrefs.data.antialiasing;
        quitBack.alpha = 0;

        add(quitBack);
        add(quit);

        
        cornorShit = new FlxSprite(0, 0).loadGraphic(Paths.image('box1'));
        cornorShit.antialiasing = ClientPrefs.data.antialiasing;
        cornorShit.color = 0xFF2b0000;
        add(cornorShit);

        vers = new FlxText(5, 0, 100, 'v0.01', 21);
        vers.font = Paths.font('3270-Regular.ttf');
        vers.color = 0xFFe55b22;
        vers.y = FlxG.height-vers.height-5;
        vers.antialiasing = ClientPrefs.data.antialiasing;
        add(vers);

        vinn = new FlxSprite(0,0).loadGraphic(Paths.image('vin'));
        vinn.antialiasing = ClientPrefs.data.antialiasing;
        vinn.alpha = 0.4;
        vinn.color = 0xFF040000;
        add(vinn);

        super.create();
        FlxG.camera.setScale(0.001, 0.001);

        add(coolMouse);

        if(FlxG.sound.music != null) FlxG.sound.music.fadeIn(4, 0, 0.7);
    }

    override function update(elapsed:Float)
    {
        if (changeScale)
        {
            if (scaleAtX < 0.9)
            {
                scaleAtY = FlxMath.lerp(scaleAtY, 0.02, FlxMath.bound(elapsed * 36, 0, 1));
                scaleAtX = FlxMath.lerp(scaleAtX, 1, FlxMath.bound(elapsed * 13, 0, 1));
            }
            else
            {
                scaleAtX = 1;
                if (scaleAtY < 0.9)
                {
                    scaleAtY = FlxMath.lerp(scaleAtY, 1, FlxMath.bound(elapsed * 25, 0, 1));
                }
                else
                {
                    scaleAtY = 1;
                    changeScale = false;
                }
            }
        }
        if(changeScale || windowsDeath)
        {
            FlxG.camera.setScale(scaleAtX, scaleAtY);
        }
        else
        {
            FlxG.camera.setScale(1, 1);
        }

        if (windowsDeath)
        {
            scaleAtY = FlxMath.lerp(scaleAtY, 0.001, FlxMath.bound(elapsed * 36, 0, 1));
            if (scaleAtY < 0.02)
                scaleAtX = FlxMath.lerp(scaleAtX, 0.001, FlxMath.bound(elapsed * 36, 0, 1));
            if (scaleAtY <= 0.001)
                Sys.exit(1);
            
        }
            
        coolMouse.x = FlxG.mouse.screenX;
        coolMouse.y = FlxG.mouse.screenY;
        super.update(elapsed);

        if (!windowsDeath)
        {
            if (FlxG.mouse.screenX >= storyBack.x && FlxG.mouse.screenX <= storyBack.x + storyBack.width)
            {
                if (FlxG.mouse.screenY >= storyBack.y && FlxG.mouse.screenY <= storyBack.y + storyBack.height)
                {
                    currentSelMouse = 0;
                    allGone();
                }
                else if (FlxG.mouse.screenY >= freeplayBack.y && FlxG.mouse.screenY <= freeplayBack.y + freeplayBack.height)
                {
                    currentSelMouse = 1;
                    allGone();
                }
                else if (FlxG.mouse.screenY >= settingsBack.y && FlxG.mouse.screenY <= settingsBack.y + settingsBack.height)
                {
                    currentSelMouse = 2;
                    allGone();
                }
                else if (FlxG.mouse.screenY >= creditsBack.y && FlxG.mouse.screenY <= creditsBack.y + creditsBack.height)
                {
                    currentSelMouse = 3;
                    allGone();
                }
                else if (FlxG.mouse.screenY >= quitBack.y && FlxG.mouse.screenY <= quitBack.y + quitBack.height)
                {
                    currentSelMouse = 4;
                    allGone();
                }
                else
                {
                    allGone();
                    currentSelMouse = -1;
                }
            }
            else
            {
                allGone();
                currentSelMouse = -1;
            }
    
            if (controls.UI_DOWN_P)
                currentSelKeys++;
            else if (controls.UI_UP_P)
                currentSelKeys--;
    
            switch(currentSelKeys)
            {
                case 0:
                    allGone();
                case 1:
                    allGone();
                case 2:
                    allGone();
                case 3:
                    allGone();
                case 4:
                    allGone();
            }
    
            if (controls.ACCEPT)
            {
                switch(currentSelKeys)
                {
                    case 0: //Story mode
                        MusicBeatState.switchState(new StoryMenuState());
                    case 1: //Freeplay
                        MusicBeatState.switchState(new FreeplayState());
                    case 2: //Settings
                        MusicBeatState.switchState(new MiniOptionState());
                        OptionsState.onPlayState = false;
                        if (PlayState.SONG != null)
                        {
                            PlayState.SONG.arrowSkin = null;
                            PlayState.SONG.splashSkin = null;
                        }
                    case 3: //Credits
                        MusicBeatState.switchState(new CreditsState());
                    case 4: //Quit
                        scaleAtY = 1;
                        scaleAtX = 1;
                        windowsDeath = true;
                }
            }
            if (FlxG.mouse.justPressed)
            {
                switch(currentSelMouse)
                {
                    case 0: //Story mode
                        MusicBeatState.switchState(new StoryMenuState());
                    case 1: //Freeplay
                        MusicBeatState.switchState(new FreeplayState());
                    case 2: //Settings
                        MusicBeatState.switchState(new MiniOptionState());
                        OptionsState.onPlayState = false;
                        if (PlayState.SONG != null)
                        {
                            PlayState.SONG.arrowSkin = null;
                            PlayState.SONG.splashSkin = null;
                        }
                    case 3: //Credits
                        MusicBeatState.switchState(new CreditsState());
                    case 4: //Quit
                        scaleAtY = 1;
                        scaleAtX = 1;
                        windowsDeath = true;
                }
            }
        }
        
    }

    function allGone()
    {
        storyBack.alpha = 0;
        freeplayBack.alpha = 0;
        settingsBack.alpha = 0;
        creditsBack.alpha = 0;
        quitBack.alpha = 0;
        story.color = 0xFFe55b22;
        freeplay.color = 0xFFe55b22;
        settings.color = 0xFFe55b22;
        credits.color = 0xFFe55b22;
        quit.color = 0xFFe55b22;

        switch(currentSelKeys)
        {
            case 0:
                storyBack.alpha = 1;
                story.color = 0xFF000000;
            case 1:
                freeplayBack.alpha = 1;
                freeplay.color = 0xFF000000;
            case 2:
                settingsBack.alpha = 1;
                settings.color = 0xFF000000;
            case 3:
                creditsBack.alpha = 1;
                credits.color = 0xFF000000;
            case 4:
                quitBack.alpha = 1;
                quit.color = 0xFF000000;
        }
        switch(currentSelMouse)
        {
            case 0:
                storyBack.alpha = 1;
                story.color = 0xFF000000;
            case 1:
                freeplayBack.alpha = 1;
                freeplay.color = 0xFF000000;
            case 2:
                settingsBack.alpha = 1;
                settings.color = 0xFF000000;
            case 3:
                creditsBack.alpha = 1;
                credits.color = 0xFF000000;
            case 4:
                quitBack.alpha = 1;
                quit.color = 0xFF000000;
        }
    }
}