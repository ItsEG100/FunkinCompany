package states;

import flixel.group.FlxGroup;
import flixel.addons.transition.FlxTransitionableState;

class ComputerState extends MusicBeatState
{

    //Setup group//

    var halfGroup:FlxGroup;

    //Setup order//
    var face:FlxSprite;
    var copy:FlxText;

    var cpu:FlxText;
    var mem:FlxText;

    var boot:FlxText;
    var copy2:FlxText;
    var detect:FlxText;
    var detect2:FlxText;
    var detect3:FlxText;

    var outLine:FlxSprite;
    var blackBox:FlxSprite;

    var utgf:FlxText;

    var body:FlxText;
    var slash:FlxText;

    var info:FlxText;

    //other//
    var text:Array<String> =
    [
        'BG IG, A System-Act Ally\nCopyright (C) 2084-2108, Halden Electronics Inc.',
        'CPU Type      :      BORSON 300 CPU at MHz',
        'Memory test   :      4521586K 0K',
        'Boot Distributioner Application v0.04',
        'Copy tight (C) 2107 D I strlbutlcner',
        'Detecting Sting X ROM',
        'Detect I ng Web LNV Extender',
        'Detecting Heartbeats 0K',
        'UTGF Device Listening...',
        'Body    ID    Neural    Device Class',
        '________________________________________',
        '2       52    Jo152          h512\n2       52    Sa5155         h512\n2       52    Bo75           h512\n2       52    Eri510         h512\n1       36    Ell567         h512\n1       36    Jos912         h512\n0',
    ];

    var coolMouse:FlxSprite;

    override function create()
    {
        coolMouse = new FlxSprite(0, 0).loadGraphic(Paths.image('ItStealsCursor'));
        coolMouse.antialiasing = ClientPrefs.data.antialiasing;
        coolMouse.scale.set(0.8, 0.8);

        halfGroup = new FlxGroup();
        add(halfGroup);

        face = new FlxSprite(50, 15);
        face.frames = Paths.getSparrowAtlas('coolFaceIconPH');
        face.animation.addByPrefix('idle', 'idle', 12, true);
        face.animation.play('idle');
        face.scale.set(0.3,0.3);
        face.color = 0xFFff5900;
        face.updateHitbox();
        face.antialiasing = ClientPrefs.data.antialiasing;
        face.alpha = 0;
        halfGroup.add(face);

        copy = new FlxText(50+face.width, 15, 1100, text[0], 27);
        copy.antialiasing = ClientPrefs.data.antialiasing;
        copy.font = Paths.font('3270-Regular.ttf');
        copy.color = 0xFFff5900;
        copy.alpha = 0;
        halfGroup.add(copy);

        cpu = new FlxText(50, 15+face.y + face.height, 1100, text[1], 27);
        cpu.antialiasing = ClientPrefs.data.antialiasing;
        cpu.font = Paths.font('3270-Regular.ttf');
        cpu.color = 0xFFff5900;
        cpu.alpha = 0;
        halfGroup.add(cpu);

        mem = new FlxText(50, cpu.y+cpu.height, 1100, text[2], 27);
        mem.antialiasing = ClientPrefs.data.antialiasing;
        mem.font = Paths.font('3270-Regular.ttf');
        mem.color = 0xFFff5900;
        mem.alpha = 0;
        halfGroup.add(mem);

        boot = new FlxText(50, mem.y + mem.height*2, 1100, text[3], 27);
        boot.antialiasing = ClientPrefs.data.antialiasing;
        boot.font = Paths.font('3270-Regular.ttf');
        boot.color = 0xFFff5900;
        boot.alpha = 0;
        halfGroup.add(boot);

        copy2 = new FlxText(50, boot.y + boot.height, 1100, text[4], 27);
        copy2.antialiasing = ClientPrefs.data.antialiasing;
        copy2.font = Paths.font('3270-Regular.ttf');
        copy2.color = 0xFFff5900;
        copy2.alpha = 0;
        halfGroup.add(copy2);

        detect = new FlxText(copy.x - 10, copy2.y + copy2.height, 1100, text[5], 27);
        detect.antialiasing = ClientPrefs.data.antialiasing;
        detect.font = Paths.font('3270-Regular.ttf');
        detect.color = 0xFFff5900;
        detect.alpha = 0;
        halfGroup.add(detect);

        detect2 = new FlxText(detect.x, detect.y + detect.height, 1100, text[6], 27);
        detect2.antialiasing = ClientPrefs.data.antialiasing;
        detect2.font = Paths.font('3270-Regular.ttf');
        detect2.color = 0xFFff5900;
        detect2.alpha = 0;
        halfGroup.add(detect2);

        detect3 = new FlxText(detect2.x, detect2.y + detect2.height, 1100, text[7], 27);
        detect3.antialiasing = ClientPrefs.data.antialiasing;
        detect3.font = Paths.font('3270-Regular.ttf');
        detect3.color = 0xFFff5900;
        detect3.alpha = 0;
        halfGroup.add(detect3);

        outLine = new FlxSprite(5, 20).loadGraphic(Paths.image('outline'));
        outLine.scale.set(0.75, 0.75);
        outLine.alpha = 0;
        outLine.color = 0xFFff5900;
        outLine.updateHitbox();
        add(outLine);

        blackBox = new FlxSprite(0, 0).makeGraphic(Math.floor(FlxG.width/2), FlxG.height, 0xFF000000);
        blackBox.x -= blackBox.width/1.4;
        blackBox.alpha = 0;
        add(blackBox);

        utgf = new FlxText(50, outLine.y+outLine.height +2, 1100, text[8], 27);
        utgf.antialiasing = ClientPrefs.data.antialiasing;
        utgf.font = Paths.font('3270-Regular.ttf');
        utgf.color = 0xFFff5900;
        utgf.alpha = 0;
        add(utgf);

        body = new FlxText(50, utgf.y+utgf.height*1.85, 1100, text[9], 27);
        body.antialiasing = ClientPrefs.data.antialiasing;
        body.font = Paths.font('3270-Regular.ttf');
        body.color = 0xFFff5900;
        body.alpha = 0;
        add(body);

        slash = new FlxText(50, body.y+body.height, 1100, text[10], 27);
        slash.antialiasing = ClientPrefs.data.antialiasing;
        slash.font = Paths.font('3270-Regular.ttf');
        slash.color = 0xFF5b2c13;
        slash.alpha = 0;
        add(slash);

        info = new FlxText(50, slash.y+body.height, 1100, text[11], 27);
        info.antialiasing = ClientPrefs.data.antialiasing;
        info.font = Paths.font('3270-Regular.ttf');
        info.color = 0xFFff5900;
        info.alpha = 0;
        add(info);

        super.create();

        add(coolMouse);

        new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			startIntro(1);
		});
    }

    override function update(elapsed:Float)
    {
        coolMouse.x = FlxG.mouse.screenX;
        coolMouse.y = FlxG.mouse.screenY;
        super.update(elapsed);
    }

    function startIntro(phase:Int)
    {
        switch(phase)
        {
            case 1:
                face.alpha = 1;
                copy.alpha = 1;
                new FlxTimer().start(0.2, function(tmr:FlxTimer)
                {
                    startIntro(2);
                });
            case 2:
                cpu.alpha = 1;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(3);
                });
            case 3:
                mem.alpha = 1;
                new FlxTimer().start(0.2, function(tmr:FlxTimer)
                {
                    startIntro(4);
                });
            case 4:
                boot.alpha = 1;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(5);
                });
            case 5:
                copy2.alpha = 1;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(6);
                });
            case 6:
                detect.alpha = 1;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(7);
                });
            case 7:
                detect2.alpha = 1;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(8);
                });
            case 8:
                detect3.alpha = 1;
                new FlxTimer().start(0.2, function(tmr:FlxTimer)
                {
                    startIntro(9);
                });
            case 9:
                halfGroup.forEach(function(t:Dynamic) t.y += copy2.height + 2);
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(10);
                });
            case 10:
                blackBox.alpha = 1;
                outLine.alpha = 1;
                utgf.alpha = 1;
                body.alpha = 1;
                slash.alpha = 1;
                info.alpha = 1;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(11);
                });
            case 11:
                blackBox.x = FlxG.width/3*1.4;
                new FlxTimer().start(0.1, function(tmr:FlxTimer)
                {
                    startIntro(12);
                });
            case 12:
                blackBox.destroy();
                new FlxTimer().start(0.3, function(tmr:FlxTimer)
                {
                    startIntro(13);
                });
            case 13:
                face.destroy();
                copy.destroy();
                cpu.destroy();
                mem.destroy();
                boot.destroy();
                copy2.destroy();
                detect.destroy();
                detect2.destroy();
                detect3.destroy();
                outLine.destroy();
                utgf.destroy();
                body.destroy();
                slash.destroy();
                info.destroy();
                new FlxTimer().start(0.2, function(tmr:FlxTimer)
                {
                    startIntro(14);
                });

            case 14:
                FlxTransitionableState.skipNextTransIn = true;
		        FlxTransitionableState.skipNextTransOut = true;
                MusicBeatState.switchState(new LethalMenuState());

        }
    }
}