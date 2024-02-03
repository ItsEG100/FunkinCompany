package states;

import backend.WeekData;
import backend.Highscore;

import lime.app.Application;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.group.FlxGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.gamepad.FlxGamepad;

import states.ComputerState;
class FlashState extends MusicBeatState
{
    var currentSection:Int = 0;
    var thereIs3ofThem:Bool = false;
    var checkboxState:Bool;
    var playesNo:Bool = false;
    var playesYes:Bool = false;
    var playesSure:Bool = false;
    var isHoveringSmth:Bool = false;
    var blockAccept:Bool = false;

    var bgThingy:FlxSprite;

    var message:FlxText;
    var yes:FlxText;
    var no:FlxText;
    var recom:FlxText;
    var choose:FlxText;
    var sure:FlxText;
    var sureCheck:FlxSprite;

    var coolStartingTrans:FlxSprite;

    
    override function create()
    {

        if (FlxG.save.data.countVisit == null)
            FlxG.save.data.countVisit = 0;
        else
            FlxG.save.data.countVisit++;


        bgThingy = new FlxSprite();
		bgThingy.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bgThingy);

        message = new FlxText(150, 100, 550, 'FLASHING LIGHTS', 65);
        message.font = Paths.font('3270-Regular.ttf');
        message.antialiasing = ClientPrefs.data.antialiasing;
        add(message);

        yes = new FlxText(180, 0, 500, 'On', 45);
        yes.screenCenter(Y);
        yes.font = Paths.font('3270-Regular.ttf');
        yes.y -= yes.height;
        yes.antialiasing = ClientPrefs.data.antialiasing;
        add(yes);

        no = new FlxText(180, 0, 500, 'Off', 45);
        no.screenCenter(Y);
        no.font = Paths.font('3270-Regular.ttf');
        no.y += yes.height;
        no.antialiasing = ClientPrefs.data.antialiasing;
        add(no);

        #if debug
        thereIs3ofThem = true;
        checkboxState = true;
        sure = new FlxText(180, 0, 500, "Show again", 45);
        sure.font = Paths.font('3270-Regular.ttf');
        sure.y = no.y + yes.height + no.height;
        sure.antialiasing = ClientPrefs.data.antialiasing;
        add(sure);

        sureCheck = new FlxSprite(0, 0);
        sureCheck.frames = Paths.getSparrowAtlas('checkbox');
        sureCheck.animation.addByPrefix('off', 'off', 1, true);
        sureCheck.animation.addByPrefix('on', 'on', 1, true);
        sureCheck.animation.play('on');
        sureCheck.scale.set(0.09, 0.09);
        sureCheck.updateHitbox();
        sureCheck.x = sure.x + 300;
        sureCheck.y = sure.y + 5;
        sureCheck.antialiasing = ClientPrefs.data.antialiasing;
        add(sureCheck);
        #else
        if (FlxG.save.data.countVisit >= 3)
        {
            thereIs3ofThem = true;
            checkboxState = true;
            sure = new FlxText(180, 0, 500, "Show again", 45);
            sure.font = Paths.font('3270-Regular.ttf');
            sure.y = no.y + yes.height + no.height;
            sure.antialiasing = ClientPrefs.data.antialiasing;
            add(sure);

            sureCheck = new FlxSprite(0, 0);
            sureCheck.frames = Paths.getSparrowAtlas('checkbox');
            sureCheck.animation.addByPrefix('off', 'off', 1, true);
            sureCheck.animation.addByPrefix('on', 'on', 1, true);
            sureCheck.animation.play('on');
            sureCheck.scale.set(0.09, 0.09);
            sureCheck.updateHitbox();
            sureCheck.x = sure.x + 300;
            sureCheck.y = sure.y + 5;
            sureCheck.antialiasing = ClientPrefs.data.antialiasing;
            add(sureCheck);
        }
        #end

        choose = new FlxText(140, 0, 20, ">", 45);
        choose.y = yes.y;
        choose.font = Paths.font('3270-Regular.ttf');
        choose.antialiasing = ClientPrefs.data.antialiasing;
        add(choose);

        recom = new FlxText(180 + 65, yes.y + yes.height, 500, '(Recommended)', 30);
        recom.font = Paths.font('3270-Regular.ttf');
        recom.y -= recom.height;
        recom.antialiasing = ClientPrefs.data.antialiasing;
        add(recom);
        

        coolStartingTrans = new FlxSprite(0, 0).loadGraphic(Paths.image('fireinthehole'));
        coolStartingTrans.antialiasing = ClientPrefs.data.antialiasing;
        coolStartingTrans.alpha = 0.5;
        add(coolStartingTrans);
        super.create();
    }

    override function update(elapsed:Float)
    {
        coolStartingTrans.alpha -= elapsed * 2;
        
        super.update(elapsed);

        if (!thereIs3ofThem)
        {
            if (controls.UI_UP_P || controls.UI_DOWN_P)
            {
                if (currentSection == 1)
                {
                    currentSection = 0;
                    choose.y = yes.y;
                } 
                else if (currentSection == 0)
                {
                    currentSection = 1;
                    choose.y = no.y;
                }  
                FlxG.sound.play(Paths.sound('hover'));    
            }
        }
        else
        {
            if (controls.UI_UP_P)
            {
                currentSection--;
                if (currentSection <= -1)
                    currentSection = 2;
                FlxG.sound.play(Paths.sound('hover'));   
            }
            else if (controls.UI_DOWN_P)
            {
                currentSection++;
                if (currentSection >= 3)
                    currentSection = 0;
                FlxG.sound.play(Paths.sound('hover'));   
            }
        }

        if (FlxG.mouse.screenX >= yes.x && FlxG.mouse.screenX <= yes.x + yes.width && FlxG.mouse.screenY >= yes.y && FlxG.mouse.screenY <= yes.y + yes.height)
        {
            currentSection = 0;
            choose.y = yes.y;
            if (!playesYes)
                FlxG.sound.play(Paths.sound('hover'));
            playesSure = false;
            playesYes = true;
            playesNo = false;
            isHoveringSmth = true;
        }
        else if (FlxG.mouse.screenX >= no.x && FlxG.mouse.screenX <= no.x + no.width && FlxG.mouse.screenY >= no.y && FlxG.mouse.screenY <= no.y + no.height)
        {
            currentSection = 1;
            choose.y = no.y;
            if (!playesNo)
                FlxG.sound.play(Paths.sound('hover'));
            playesSure = false;
            playesYes = false;
            playesNo = true;
            isHoveringSmth = true;
        }
        else if (thereIs3ofThem && (FlxG.mouse.screenX >= sure.x && FlxG.mouse.screenX <= sure.x + sure.width && FlxG.mouse.screenY >= sure.y && FlxG.mouse.screenY <= sure.y + sure.height))
        {
            currentSection = 2;
            if (!playesSure)
                FlxG.sound.play(Paths.sound('hover'));
            playesSure = true;
            playesYes = false;
            playesNo = false;
            isHoveringSmth = true;
        }
        else
        {
            isHoveringSmth = false;
        }
        if(currentSection == 0)
            choose.y = yes.y;
        else if (currentSection == 1)
            choose.y = no.y;
        else if (currentSection == 2)
            choose.y = sure.y;

        if (!blockAccept && (controls.ACCEPT || (FlxG.mouse.justPressed && isHoveringSmth)))
        {
            FlxG.sound.play(Paths.sound('press'));
            if (thereIs3ofThem && currentSection == 2)
                chengeThis();
            else
            {
                
                if (currentSection == 0)
                    ClientPrefs.data.flashing = true;
                else if (currentSection == 1)
                    ClientPrefs.data.flashing = false;
                ClientPrefs.saveSettings();
                FlxTransitionableState.skipNextTransIn = true;
		        FlxTransitionableState.skipNextTransOut = true;
                blockAccept = true;
                die();
            }
        }
    }

    function die()
    {
        new FlxTimer().start(0.15, function(tmr:FlxTimer)
        {
            MusicBeatState.switchState(new ComputerState());
        });
    }

    function chengeThis()
    {
        if (checkboxState)
        {
            FlxG.save.data.showFlash = false;
            sureCheck.animation.play('off');
            checkboxState = false;
        }
        else
        {
            FlxG.save.data.showFlash = true;
            sureCheck.animation.play('on');
            checkboxState = true;
        }
    }
}