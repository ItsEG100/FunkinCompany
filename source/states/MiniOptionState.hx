package states;
import backend.ClientPrefs;
import haxe.display.Display.Package;
import flixel.util.FlxSort;

import backend.InputFormatter;
import states.LethalMenuState;

import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;

class MiniOptionState extends MusicBeatState
{
    var keysOption:Array<Array<Dynamic>> = 
    [
      //[is button?,    Line,  Position,   Name,       Incode name,    ],
        [false,         0,     0,          'Gameplay'                  ],//0
        [true,          1,     0,          'Left',     'note_left',    ],//1
        [true,          1,     1,          'Right',    'note_right',   ],//2
        [true,          1,     2,          'Reset',    'reset',        ],//3
        [true,          2,     0,          'Up',       'note_up',      ],//4
        [true,          2,     1,          'Down',     'note_down',    ],//5
        [true,          2,     2,          'Pause',    'pause',        ],//6
        [false,         3,     0,          'UI'                        ],//7
        [true,          4,     0,          'Left',     'ui_left',      ],//8
        [true,          4,     1,          'Right',    'ui_right',     ],//9
        [true,          4,     2,          'Accept',   'accept',       ],//10
        [true,          5,     0,          'Up',       'ui_up',        ],//11
        [true,          5,     1,          'Down',     'ui_down',      ],//12
        [true,          5,     2,          'Back',     'back',         ],//13
    ];
    var other:Array<Array<Dynamic>> = [
        ['name', 'left', 'Preferences'],
        ['checkbox', 'left', 'Anti-Aliasing', ClientPrefs.data.antialiasing],
        ['slider', 'left', 'Scroll Direction', FlxG.save.data.downScrollV, ['Up', 'Down'], 0, 1, [false, true]],
        ['checkbox', 'left', 'Ghost Tapping', ClientPrefs.data.ghostTapping],
        ['slider', 'left', 'FPS', FlxG.save.data.framerateV, [30, 60, 120, 144, 240], 2, 5, [30, 60, 120, 144, 240]],
        [],
        ['checkbox', 'left', 'FPS Counter', ClientPrefs.data.showFPS],
        ['checkbox', 'left', 'Camera Zoom on Beat', ClientPrefs.data.camZooms],
        ['checkbox', 'left', 'GPU Caching', ClientPrefs.data.cacheOnGPU],
        ['checkbox-save', 'left', 'Show Flashing Lights menu', FlxG.save.data.showFlash],
        ['button-state', 'right', 'Delay and Combo adjustment'],
        ['button-state', 'right', '>BACK<'],
        ['button', 'right', '>Confirm'],
        ['button', 'right', '>Reset keybinds'],
    ];
    var blackBg:FlxSprite;
    var halfBlackBg:FlxSprite;

    var textOfSettings:FlxTypedGroup<FlxText>;
    var textOfKeys:FlxTypedGroup<KeyText>;
    var groupOfChecks:FlxTypedGroup<Checkbox>;
    var groupOfButtons:FlxTypedGroup<Button>;
    var groupOfSliders:FlxTypedGroup<Slider>;

    var changingText:FlxText;
    var pressToCancel:FlxText;
    var pressToRemove:FlxText;

    var position:FlxPoint = new FlxPoint(0, 0);
    var curWidth:Float;
    var newWidth:Float;
    
    var changedSMTH:Bool = false;
    var menuShow:Bool;
    var checkyText:FlxText;
    var checkyBox:FlxSprite;

    var wowYouDidntSave:FlxText;
    var ohYeahSaveItPlease:FlxText;
    var okIllSave:FlxText;
    var fuckTheSaving:FlxText;

    override function create()
    {
        //blackBg = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        //add(blackBg);

        if (FlxG.save.data.framerateV != null)
            other[4][5] = FlxG.save.data.framerateV;
        else 
            other[4][5] = 1;

        if (!ClientPrefs.data.downScroll)
            other[2][5] = 0;
        else 
            other[2][5] = 1;

        if(FlxG.save.data.showFlash != null)
            menuShow = FlxG.save.data.showFlash;
        else 
            menuShow = true;

        textOfSettings = new FlxTypedGroup();
        textOfKeys = new FlxTypedGroup();
        add(textOfSettings);
        add(textOfKeys);
        for (items in 0...keysOption.length)
        {
            switch(keysOption[items][1])
            {
                case 0:
                    position.y = 40;
                case 1:
                    position.y = 90;
                case 2:
                    position.y = 130;
                case 3:
                    position.y = 210;
                case 4:
                    position.y = 260;
                case 5:
                    position.y = 300;
            }
            switch(keysOption[items][2])
            {
                case 0:
                    position.x = 10;
                case 1:
                    position.x = 360;
                case 2:
                    position.x = 710;
            }
            if (keysOption[items][0])
            {
                var curThing:FlxText = new FlxText(position.x, position.y, 0, keysOption[items][3], 30);
                curThing.alpha = 0.75;
                curThing.ID = items;
                curThing.text += ":";
                curThing.font = Paths.font('3270-Regular.ttf');
                curThing.antialiasing = ClientPrefs.data.antialiasing;
                textOfSettings.add(curThing);
            }
            else
            {
                var curThing:FlxText = new FlxText(position.x, position.y, 0, keysOption[items][3], 30);
                curThing.alpha = 0.75;
                curThing.font = Paths.font('3270-Regular.ttf');
                curThing.antialiasing = ClientPrefs.data.antialiasing;
                add(curThing);
            }
            
        }
        textOfSettings.forEach(function(t:FlxText) 
        {
            newWidth = t.width;
            if (newWidth >= curWidth)
                curWidth = newWidth;
            
        });
        textOfSettings.forEach(function(t:FlxText) {
            switch(keysOption[t.ID][1])
            {
                case 0:
                    position.y = 40;
                case 1:
                    position.y = 90;
                case 2:
                    position.y = 130;
                case 3:
                    position.y = 210;
                case 4:
                    position.y = 260;
                case 5:
                    position.y = 300;
            }
            switch(keysOption[t.ID][2])
            {
                case 0:
                    position.x = 10;
                case 1:
                    position.x = 360;
                case 2:
                    position.x = 710;
            }
            changeKeyBind(t.text, t.ID);
        });

        var curYLeft:Float = 325;
        var curYRight:Float = 520;
        var sliderY:Float = 325;

        add(groupOfButtons = new FlxTypedGroup());
        add(groupOfChecks = new FlxTypedGroup());
        add(groupOfSliders = new FlxTypedGroup());
        for (i in 0...other.length)
        {
            switch (other[i][0])
            {
                case 'name':
                    var nameText:FlxText = new FlxText((other[i][1] == 'left') ? 10 : 1000, (other[i][1] == 'left') ? curYLeft : curYRight, 0, other[i][2], 30);
                    nameText.font = Paths.font('3270-Regular.ttf');
                    nameText.antialiasing = ClientPrefs.data.antialiasing;
                    add(nameText);
                case 'checkbox':
                    var checkText:Checkbox = new Checkbox((other[i][1] == 'left') ? 10 : 1000, (other[i][1] == 'left') ? curYLeft : curYRight, 0, other[i][2], 30, other[i][3]);
                    checkText.ID = i;
                    groupOfChecks.add(checkText);
                case 'checkbox-save':
                    checkyText = new FlxText(25+10, curYLeft, 0, other[i][2], 30);
                    checkyText.font = Paths.font('3270-Regular.ttf');
                    checkyText.antialiasing = ClientPrefs.data.antialiasing;
                    add(checkyText);
                    checkyBox = new FlxSprite(10, curYLeft);
                    checkyBox.frames = Paths.getSparrowAtlas('checkbox');
                    checkyBox.scale.set(0.065, 0.065);
                    checkyBox.updateHitbox();
                    checkyBox.animation.addByPrefix('off', 'off', 1, true);
                    checkyBox.animation.addByPrefix('on', 'on', 1, true);
                    checkyBox.animation.play((other[i][3]) ? 'on' : 'off');
                    checkyBox.x = checkyText.x - 25;
                    checkyBox.y = checkyText.y + (checkyText.height - checkyBox.height) / 2;
                    add(checkyBox);
                case 'button':
                    var buttonText:Button = new Button((other[i][1] == 'left') ? 10 : 850, (other[i][1] == 'left') ? curYLeft : curYRight, 0, other[i][2], 30);
                    buttonText.ID = i;
                    buttonText.font = Paths.font('3270-Regular.ttf');
                    buttonText.antialiasing = ClientPrefs.data.antialiasing;
                    groupOfButtons.add(buttonText);
                case 'button-state':
                    var buttonText:Button = new Button((other[i][1] == 'left') ? 10 : 850, (other[i][1] == 'left') ? curYLeft : curYRight, 0, other[i][2], 30);
                    buttonText.ID = i;
                    buttonText.font = Paths.font('3270-Regular.ttf');
                    buttonText.antialiasing = ClientPrefs.data.antialiasing;
                    buttonText.isState = true;
                    groupOfButtons.add(buttonText);
                case 'slider':
                    var name:FlxText = new FlxText(440, sliderY, 0, other[i][2]+":", 30);
                    name.antialiasing = ClientPrefs.data.antialiasing;
                    name.font = Paths.font('3270-Regular.ttf');
                    name.ID = 1000;
                    textOfSettings.add(name);
                    var sliderShit:Slider = new Slider(440, name.y + name.height+10, 300, 55, other[i][6]+1);
                    sliderShit.ID = i;
                    sliderShit.curSel = other[i][5];
                    sliderShit.createText(other[i][4]);
                    groupOfSliders.add(sliderShit);
                    sliderY += name.height+55 + 10+35;

                    if (other[i][1] == 'left')
                        curYLeft -= 35;
                    else 
                        curYRight -= 35;
                default:
                    
            }

            if (other[i][1] == 'left')
                curYLeft += 35;
            else 
                curYRight += 35;
        }

        halfBlackBg = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        halfBlackBg.alpha = 0;
        add(halfBlackBg);
        changingText = new FlxText(0, 0, 0, 'You changing [] keybind.,', 35);
        changingText.font = Paths.font('3270-Regular.ttf');
        changingText.updateHitbox();
        changingText.screenCenter(XY);
        changingText.y -= 50;
        changingText.antialiasing = ClientPrefs.data.antialiasing;
        changingText.alpha = 0;
        add(changingText);
        //Press ESC or Click on this text to cancel
        pressToCancel = new FlxText(0, 0, 0, 'Press ESC or Click on this to cancel', 25);
        pressToCancel.font = Paths.font('3270-Regular.ttf');
        pressToCancel.alignment = CENTER;
        pressToCancel.color = 0xFFBEBEBE;
        pressToCancel.updateHitbox();
        pressToCancel.screenCenter(XY);
        pressToCancel.antialiasing = ClientPrefs.data.antialiasing;
        pressToCancel.alpha = 0;
        add(pressToCancel);
         
        pressToRemove = new FlxText(0, 0, 0, 'Press Backspace or Click on this to remove', 25);
        pressToRemove.font = Paths.font('3270-Regular.ttf');
        pressToRemove.alignment = CENTER;
        pressToRemove.color = 0xFFBEBEBE;
        pressToRemove.updateHitbox();
        pressToRemove.screenCenter(XY);
        pressToRemove.y += pressToCancel.height + 20;
        pressToRemove.antialiasing = ClientPrefs.data.antialiasing;
        pressToRemove.alpha = 0;
        add(pressToRemove);

        wowYouDidntSave = new FlxText(0, 0, 0, 'Hey! Not that fast! You forget to save your changes!', 35);
        wowYouDidntSave.font = Paths.font('3270-Regular.ttf');
        wowYouDidntSave.updateHitbox();
        wowYouDidntSave.screenCenter(XY);
        wowYouDidntSave.y -= 100;
        wowYouDidntSave.antialiasing = ClientPrefs.data.antialiasing;
        wowYouDidntSave.alpha = 0;
        add(wowYouDidntSave);

        ohYeahSaveItPlease = new FlxText(0, 0, 0, 'Save changes and exit', 30);
        ohYeahSaveItPlease.font = Paths.font('3270-Regular.ttf');
        ohYeahSaveItPlease.alignment = CENTER;
        ohYeahSaveItPlease.color = 0xFFC28F8F;
        ohYeahSaveItPlease.updateHitbox();
        ohYeahSaveItPlease.screenCenter(XY);
        ohYeahSaveItPlease.antialiasing = ClientPrefs.data.antialiasing;
        ohYeahSaveItPlease.alpha = 0;
        add(ohYeahSaveItPlease);

        okIllSave = new FlxText(0, 0, 0, "Don't exit", 30);
        okIllSave.font = Paths.font('3270-Regular.ttf');
        okIllSave.alignment = CENTER;
        okIllSave.color = 0xFFC28F8F;
        okIllSave.updateHitbox();
        okIllSave.screenCenter(XY);
        okIllSave.x = FlxG.width / 4 - 75;
        okIllSave.y += ohYeahSaveItPlease.height + 20;
        okIllSave.antialiasing = ClientPrefs.data.antialiasing;
        okIllSave.alpha = 0;
        add(okIllSave);

        fuckTheSaving = new FlxText(0, 0, 0, "Exit", 30);
        fuckTheSaving.font = Paths.font('3270-Regular.ttf');
        fuckTheSaving.alignment = CENTER;
        fuckTheSaving.color = 0xFFC28F8F;
        fuckTheSaving.updateHitbox();
        fuckTheSaving.screenCenter(XY);
        fuckTheSaving.x = FlxG.width / 4 + FlxG.width / 2;
        fuckTheSaving.y += ohYeahSaveItPlease.height + 20;
        fuckTheSaving.antialiasing = ClientPrefs.data.antialiasing;
        fuckTheSaving.alpha = 0;
        add(fuckTheSaving);

        super.create();
    }

    var savKey:Array<Dynamic>; 
    function changeKeyBind(text:String, myId:Int) {
        for (n in 0...2)
        {
            var key:Dynamic = null;
            switch (myId)
            {
                case 1 | 4 | 8 | 11:
                    position.x = 10;
                case 2 | 5 | 9 | 12:
                    position.x = 360;
                case 3 | 6 | 10 | 13:
                    position.x = 710;
            }
            savKey = ClientPrefs.keyBinds.get(keysOption[myId][4]);
            key = InputFormatter.getKeyName((savKey[n] != null) ? savKey[n] : NONE);
            var keyText:KeyText = new KeyText(position.x + n * 105 + curWidth, position.y, 0, key, 30);
            keyText.font = Paths.font('3270-Regular.ttf');
            keyText.antialiasing = ClientPrefs.data.antialiasing;
            keyText.buttonID = n;
            keyText.ID = myId;
            textOfKeys.add(keyText);
        }
    }

    var changingBut:Bool = false;
    var sliderOpen:Bool = false;
    var momentOfTruth:Int;
    var exitMoment:Bool = false;
    var updatingKeybinds:Bool = false;
    override function update(elapsed:Float) 
    {
        if (!exitMoment)
        {

            if (!changingBut && !sliderOpen)
            {
                ClientPrefs.toggleVolumeKeys(true);
                if (!updatingKeybinds)
                {
                    textOfKeys.forEach(function(t:KeyText) {
                        
                            if (FlxG.mouse.overlaps(t))
                                t.isSel = true;
                            else 
                                t.isSel = false;
                    
                        if (t.isSel && FlxG.mouse.justPressed)
                        {
                            changingBut = true;
                            appearPlease();
                        }
                    });
                }
                checkyBox.animation.play((FlxG.save.data.showFlash) ? 'on' : 'off');
                if (FlxG.mouse.overlaps(checkyBox) || FlxG.mouse.overlaps(checkyText))
                {
                    checkyText.color = 0xFFe55b22;
                    checkyBox.color = 0xFFe55b22;
                    if (FlxG.mouse.justPressed)
                        FlxG.save.data.showFlash = !FlxG.save.data.showFlash;
                }
                else 
                {
                    checkyBox.color = 0xFFffffff;
                    checkyText.color = 0xFFffffff;
                }
                groupOfButtons.forEach(function(b:Button)
                {
                    if (FlxG.mouse.overlaps(b))
                    {
                        b.isSel = true;
                        if (FlxG.mouse.justPressed)
                        {
                            if (b.isState)
                            {
                                if (changedSMTH)
                                    warnPlayer(b.ID);
                                else 
                                {
                                    if (b.ID == 11)
                                        MusicBeatState.switchState(new LethalMenuState());
                                    else 
                                        MusicBeatState.switchState(new options.NoteOffsetState());
    
                                }
                            }
                            else
                            {
                                if(b.ID == 13)
                                {
                                    textOfKeys.forEach(function(k:KeyText) {k.destroy();});
                                    ClientPrefs.resetKeys();
                                    ClientPrefs.reloadVolumeKeys();
                                    FlxG.sound.play(Paths.sound('cancelMenu'));
                                    changedSMTH = true;
                                    updatingKeybinds = true;
                                    FlxTransitionableState.skipNextTransIn = true;
		                            FlxTransitionableState.skipNextTransOut = true;
                                    MusicBeatState.switchState(new MiniOptionState());
                                }
                                else
                                {
                                    ClientPrefs.saveSettings();
                                    changedSMTH = false;
                                }
                            }
                        }
                    }
                    else 
                    {
                        b.isSel = false;
                    }
                });
                groupOfSliders.forEach(function(s:Slider) {
                    if (FlxG.mouse.screenX >= s.what[0][0] && FlxG.mouse.screenX <= s.what[0][0] + s.what[0][2] && FlxG.mouse.screenY >= s.what[0][1] && FlxG.mouse.screenY <= s.what[0][1] + s.what[0][3])
                    {
                        if (FlxG.mouse.justPressed)
                        {
                            sliderOpen = true;
                            s.isOpened = true;
                        }
                        s.isSel = true;
                    }
                    else if (!s.isOpened)
                    {
                        s.isSel = false;
                    }
                });
    
                groupOfChecks.forEach(function(c:Checkbox) {
                    if (FlxG.mouse.overlaps(c))
                        c.isSel = true;
                    else 
                        c.isSel = false;
    
                    if (c.isSel && FlxG.mouse.justPressed)
                    {
                        other[c.ID][3] = !other[c.ID][3];
                        c.curState = other[c.ID][3];
                        ClientPrefs.data.antialiasing = other[1][3];
                        ClientPrefs.data.ghostTapping = other[3][3];
                        ClientPrefs.data.showFPS = other[6][3];
                        ClientPrefs.data.camZooms = other[7][3];
                        ClientPrefs.data.cacheOnGPU = other[8][3];
                        changedSMTH = true;
                        onChangeAntiAliasing();
                        onChangeFPSCounter();
                    }
                });
            }
            else if (changingBut)
            {
                ClientPrefs.toggleVolumeKeys(false);
                halfBlackBg.alpha += elapsed * 0.9;
                changingText.alpha += elapsed * 1.8;
                pressToCancel.alpha += elapsed * 1.8;
                pressToRemove.alpha += elapsed * 1.8;
                if (halfBlackBg.alpha >= 0.5)
                    halfBlackBg.alpha = 0.5;
                if (FlxG.mouse.overlaps(pressToCancel))
                {
                    pressToCancel.color = 0xFFbe0000;
                    if (FlxG.mouse.justPressed)
                    {
                        changingBut = false;
                        halfBlackBg.alpha = 0;
                        changingText.alpha = 0;
                        pressToRemove.alpha = 0;
                        pressToCancel.alpha = 0;
                    }
                }
                else 
                {
                    pressToCancel.color = 0xFFbebebe;
                }
    
                if (FlxG.mouse.overlaps(pressToRemove))
                {
                    pressToRemove.color = 0xFFbe0000;
                    if (FlxG.mouse.justPressed)
                    {
                        textOfKeys.forEach(function(t:KeyText) {
                            if (t.isSel)
                            {
                                ClientPrefs.keyBinds.get(keysOption[t.ID][4])[t.buttonID] = NONE;
                                ClientPrefs.clearInvalidKeys(keysOption[t.ID][4]);
                                t.text = InputFormatter.getKeyName(NONE);
                            }
                        });
                        changedSMTH = true;
                    }
                }
                else 
                {
                    pressToRemove.color = 0xFFbebebe;
                }
                textOfKeys.forEach(function(t:KeyText) {
                    if (FlxG.keys.justPressed.ESCAPE)
                    {
                        changingBut = false;
                        halfBlackBg.alpha = 0;
                        changingText.alpha = 0;
                        pressToRemove.alpha = 0;
                        pressToCancel.alpha = 0;
                    }
                    else if (FlxG.keys.justPressed.BACKSPACE)
                    {
                        if (t.isSel)
                        {
                            ClientPrefs.keyBinds.get(keysOption[t.ID][4])[t.buttonID] = NONE;
                            ClientPrefs.clearInvalidKeys(keysOption[t.ID][4]);
                            t.text = InputFormatter.getKeyName(NONE);
                        }
                        changedSMTH = true;
                        changingBut = false;
                        halfBlackBg.alpha = 0;
                        changingText.alpha = 0;
                        pressToRemove.alpha = 0;
                        pressToCancel.alpha = 0;
                        
                    } 
                    else 
                    {
                        if (t.isSel)
                        {
                            if (FlxG.keys.justPressed.ANY && (!FlxG.keys.justPressed.BACKSPACE || !FlxG.keys.justPressed.ESCAPE))
                            {
                                var keyPressed:Int = FlxG.keys.firstJustPressed();
                                var keyReleased:Int = FlxG.keys.firstJustReleased();
                                ClientPrefs.keyBinds.get(keysOption[t.ID][4])[t.buttonID] = keyPressed;
                                ClientPrefs.clearInvalidKeys(keysOption[t.ID][4]);
                                var fastKey:Array<Dynamic> = ClientPrefs.keyBinds.get(keysOption[t.ID][4]);
                                t.text = InputFormatter.getKeyName((fastKey[t.buttonID] != null) ? fastKey[t.buttonID] : NONE);
                                changingBut = false;
                                halfBlackBg.alpha = 0;
                                changingText.alpha = 0;
                                pressToRemove.alpha = 0;
                                pressToCancel.alpha = 0;
    
                                changedSMTH = true;
                            }
                        }
                    }
                });
            }
            else if (sliderOpen)
            {
                var dad:Dynamic;
                groupOfSliders.forEach(function(s:Slider) {
                    if (s.isOpened)
                    {
                        if (FlxG.mouse.screenX >= s.what[1][0] && FlxG.mouse.screenX <= s.what[1][0] + s.what[1][2] && FlxG.mouse.screenY >= s.what[1][1] && FlxG.mouse.screenY <= s.what[1][1] + s.what[1][3])
                        {
                            if(FlxG.mouse.justPressed)
                            {
                                s.updateText(s.wantSel);
                                dad = s.curSel;
                                if (s.ID == 4)
                                {
                                    switch (dad) {
                                        case 0:
                                            ClientPrefs.data.framerate = 30;
                                        case 1:
                                            ClientPrefs.data.framerate = 60;
                                        case 2:
                                            ClientPrefs.data.framerate = 120;
                                        case 3:
                                            ClientPrefs.data.framerate = 144;
                                        case 4:
                                            ClientPrefs.data.framerate = 240;
                                        default:
                                            ClientPrefs.data.framerate = 60;
                                    }
                                    onChangeFramerate();
                                }
                                else {
                                    ClientPrefs.data.downScroll = other[2][7][dad];
                                }
                                changedSMTH = true;
                                s.isOpened = false;
                                sliderOpen = false;
                                trace("ds" + ClientPrefs.data.downScroll);
                                trace("fps" + ClientPrefs.data.framerate);
                            }
                        }
                        else 
                        {
                            if(FlxG.mouse.justPressed)
                            {
                                s.isOpened = false;
                                sliderOpen = false;
                            }
                        }    
                    } 
                    else 
                    {
                        s.nonThisSel = true;
                    }
                });
            }
        }
        else 
        {
            halfBlackBg.alpha += elapsed * 0.9;
            wowYouDidntSave.alpha += elapsed * 1.8;
            ohYeahSaveItPlease.alpha += elapsed * 1.8;
            okIllSave.alpha += elapsed * 1.8;
            fuckTheSaving.alpha += elapsed * 1.8;
            if (halfBlackBg.alpha >= 0.5)
                halfBlackBg.alpha = 0.5;

            if (FlxG.mouse.overlaps(ohYeahSaveItPlease))
            {
                ohYeahSaveItPlease.color = 0xFFbe0000;
                if (FlxG.mouse.justPressed)
                {
                    ClientPrefs.saveSettings();
                    if (momentOfTruth == 11)
                        MusicBeatState.switchState(new LethalMenuState());
                    else 
                        MusicBeatState.switchState(new options.NoteOffsetState());
                }
            }
            else
            {
                ohYeahSaveItPlease.color = 0xFFC28F8F;
            }
            if (FlxG.mouse.overlaps(fuckTheSaving))
            {
                fuckTheSaving.color = 0xFFbe0000;
                if (FlxG.mouse.justPressed)
                {
                    if (momentOfTruth == 11)
                        MusicBeatState.switchState(new LethalMenuState());
                    else 
                        MusicBeatState.switchState(new options.NoteOffsetState());
                }
            }
            else
            {
                fuckTheSaving.color = 0xFFC28F8F;
            }

            if (FlxG.mouse.overlaps(okIllSave))
            {
                okIllSave.color = 0xFFbe0000;
                if (FlxG.mouse.justPressed)
                {
                    halfBlackBg.alpha = 0;
                    okIllSave.alpha = 0;
                    fuckTheSaving.alpha = 0;
                    ohYeahSaveItPlease.alpha = 0;
                    wowYouDidntSave.alpha = 0;
                    exitMoment = false;
                }
            }
            else
            {
                okIllSave.color = 0xFFC28F8F;
            }
        }

        super.update(elapsed);
    }
    
    function warnPlayer(stateID) {
        momentOfTruth = stateID;
        exitMoment = true;
    }
    function onChangeFPSCounter()
    {
        trace('Updating FPS Counter');
        if(Main.fpsVar != null)
            Main.fpsVar.visible = ClientPrefs.data.showFPS;
    }
    
    var wowText:String;
    var curButton:Int;
    function appearPlease() {
        textOfKeys.forEach(function(t:KeyText)
        {
            if (t.isSel)
                curButton = t.ID;
        });
        textOfSettings.forEach(function(t:FlxText) {
           if(t.ID == curButton)
                if(t.ID == 1 || t.ID == 2 || t.ID == 3 || t.ID == 4)
                    wowText = 'Gameplay '+ keysOption[t.ID][3]; 
                else if (t.ID == 8 || t.ID == 9 || t.ID == 10 || t.ID == 11)
                    wowText = 'UI ' + keysOption[t.ID][3]; 
                else
                    wowText = keysOption[t.ID][3];
        });
        changingText.text = 'You changing '+wowText+' keybind.';
        changingText.screenCenter(XY);
        changingText.y -= 50;
    }

    function onChangeAntiAliasing()
    {
        trace('Updating Antialiasing');
        for (sprite in members)
        {
            var sprite:FlxSprite = cast sprite;
            if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
                sprite.antialiasing = ClientPrefs.data.antialiasing;
            }
        }

        groupOfSliders.forEach(function(s:Slider) {
            s.changeAntial();
        });
        groupOfChecks.forEach(function(c:Checkbox) {
            c.changeAntial();
        });
    }
    
    function onChangeFramerate()
    {
        trace('Updating FPS');
        if(ClientPrefs.data.framerate > FlxG.drawFramerate)
        {
            FlxG.updateFramerate = ClientPrefs.data.framerate;
            FlxG.drawFramerate = ClientPrefs.data.framerate;
        }
        else
        {
            FlxG.drawFramerate = ClientPrefs.data.framerate;
            FlxG.updateFramerate = ClientPrefs.data.framerate;
        }
    }
}

class KeyText extends FlxText {
    public var isSel:Bool = false;
    public var buttonID:Int = 0;
    public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, ?text:String = '', ?size:Int = 8) 
    {
        super(x, y, fieldWidth, text, size);
    }
    override function update(elapsed:Float) 
    {
        super.update(elapsed);
        if (isSel)
            this.color = 0xFFe55b22;
        else
            this.color = 0xFFFFFFFF;
    }
}

class Slider extends FlxGroup {
    var fuckingSecondBGBox:FlxSprite;
    var fuckingSecondBGBigBox:FlxSprite;
    var fuckingBox:FlxSprite;
    var fuckingBigBox:FlxSprite;
    var fuckingText:FlxText;
    var fuckingArrow:FlxSprite;
    var fuckingSelectBox:FlxSprite;
    
    
    var texts:FlxTypedGroup<KeyText>;
    var options:Array<String> = [];
    public var keyPositions:Array<Array<Dynamic>> = [];
    public var what:Array<Array<Dynamic>> = [];
    
    
    public var isOpened:Bool = false;
    public var curSel:Int = 0;
    public var wantSel:Int = 0;
    public var isSel:Bool = false;
    public var nonThisSel:Bool = false;
    var randomAssH:Float;
    public function new(x:Float = 0, y:Float = 0, w:Int = 0, h:Int = 0, amound:Int = 1) {
        
        super();

        fuckingSecondBGBox = new FlxSprite(x, y).makeGraphic(w, Math.ceil(h+(h*amound*0.5)), 0xFF50200c);
        fuckingSecondBGBox.antialiasing = ClientPrefs.data.antialiasing;
        add(fuckingSecondBGBox);
        
        fuckingBox = new FlxSprite(x + 5, y + 5).makeGraphic(w - 10, Math.ceil(h+(h*amound*0.5) - 10), 0xFF000000);
        fuckingBox.antialiasing = ClientPrefs.data.antialiasing;
        fuckingBox.updateHitbox();
        add(fuckingBox);

        var smallFastTextToTestRandomAssShitDontMindItPlease:FlxText = new FlxText(0, 0, 0, "QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,./1234567890-=`~!@#$%^&*()_+|}{:<>?" + '"', 28);
        smallFastTextToTestRandomAssShitDontMindItPlease.font = Paths.font('3270-Regular.ttf');
        randomAssH = smallFastTextToTestRandomAssShitDontMindItPlease.height;
        smallFastTextToTestRandomAssShitDontMindItPlease.destroy();

        fuckingSelectBox = new FlxSprite();//0xFF753215
        fuckingSelectBox.antialiasing = ClientPrefs.data.antialiasing;
        add(fuckingSelectBox);
        add(texts = new FlxTypedGroup());
        
        fuckingSecondBGBigBox = new FlxSprite(x, y).makeGraphic(w, h, 0xFFFFFFFF);
        fuckingSecondBGBigBox.antialiasing = ClientPrefs.data.antialiasing;
        add(fuckingSecondBGBigBox);
        
        fuckingBigBox = new FlxSprite(x + 5, y + 5).makeGraphic(w - 10, h - 10, 0xFF000000);
        fuckingBigBox.antialiasing = ClientPrefs.data.antialiasing;
        add(fuckingBigBox);
        
        fuckingText = new FlxText(x, y, 0, '', 45);
        fuckingText.font = Paths.font('3270-Regular.ttf');
        fuckingText.antialiasing = ClientPrefs.data.antialiasing;
        fuckingText.alignment = CENTER;
        fuckingText.updateHitbox();
        add(fuckingText);

        fuckingSelectBox.x = fuckingBigBox.x;
        fuckingSelectBox.y = fuckingBigBox.y + randomAssH + randomAssH * 1 * 0.8;

        fuckingArrow = new FlxSprite(fuckingBigBox.x + fuckingBigBox.width * 0.8, y + 5).loadGraphic(Paths.image('arrow2'));
        fuckingArrow.angle = 180;
        fuckingArrow.antialiasing = ClientPrefs.data.antialiasing;
        fuckingArrow.scale.set(0.15, 0.15);
        fuckingArrow.updateHitbox();
        add(fuckingArrow);

        what[0] = [fuckingSecondBGBigBox.x, fuckingSecondBGBigBox.y, fuckingSecondBGBigBox.width, fuckingSecondBGBigBox.height];
        what[1] = [fuckingSecondBGBox.x, fuckingSecondBGBox.y, fuckingSecondBGBox.width, fuckingSecondBGBox.height];
        trace(fuckingSecondBGBigBox +' || '+ fuckingSecondBGBox);
    }
    
    public function createText(wowText:Array<String>)
    {
        for (i in 0...wowText.length)
        {
            var newText:KeyText = new KeyText(fuckingBigBox.x, fuckingBigBox.y + randomAssH + randomAssH * i * 0.8 + 10, 0, wowText[i], 30);
            newText.ID = i;
            newText.antialiasing = ClientPrefs.data.antialiasing;
            newText.color = 0xFFe55b22;
            newText.font = Paths.font('3270-Regular.ttf');
            newText.alignment = CENTER;
            newText.updateHitbox();
            texts.add(newText);
            fuckingSelectBox.makeGraphic(Math.floor(fuckingBigBox.width), Math.floor(newText.height), 0xFF753215);
            if (newText.ID == curSel)
                fuckingSelectBox.y = newText.y;
            fuckingSelectBox.alpha = 0;
        }
        options = wowText;
        fuckingText.text = wowText[curSel];
        fuckingText.y = fuckingBigBox.y + (fuckingBigBox.height + fuckingText.height) / 2 - 50;
        fuckingText.x = fuckingBigBox.x + 5;
        wantSel = curSel;

    }

    public function updateText(selection) {
        fuckingText.text = options[selection];
        curSel = selection;
        trace(options[selection]);
    }

    public function changeAntial()
    {
        for (sprite in members)
        {
            var sprite:FlxSprite = cast sprite;
            if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
                sprite.antialiasing = ClientPrefs.data.antialiasing;
            }
        }
    }

    var intendetLearp:Float = 0;
    var floatingLearp:Float = 0;
    override function update(elapsed:Float) {
        floatingLearp = FlxMath.lerp(floatingLearp, intendetLearp, FlxMath.bound(elapsed * 18, 0, 1));
        super.update(elapsed);     
        fuckingSecondBGBox.alpha = floatingLearp;
        fuckingBox.alpha =  floatingLearp;
        fuckingArrow.angle = 180 + floatingLearp * 180;
        fuckingSelectBox.alpha = floatingLearp;
        texts.forEach(function(t:KeyText)
        {
            t.alpha = floatingLearp;

            if (FlxG.mouse.x >= fuckingSecondBGBox.x && FlxG.mouse.x <= fuckingSecondBGBox.x + fuckingSecondBGBox.width  && FlxG.mouse.y >= t.y && FlxG.mouse.y <= t.y + t.height && isOpened)
            {
                fuckingSelectBox.y = t.y;
                wantSel = t.ID;
            }
        });

        if (isSel)
        {
            fuckingSecondBGBigBox.color = 0xFFe55b22;
            fuckingText.color = 0xFFe55b22;
            fuckingArrow.color = 0xFFe55b22;
        }
        else 
        {
            fuckingSecondBGBigBox.color = 0xFFffffff;
            fuckingText.color = 0xFFffffff;
            fuckingArrow.color = 0xFFffffff;
        }

        if (isOpened)
            intendetLearp = 1;
        else 
            intendetLearp = 0;
    }
}

class Checkbox extends FlxGroup {
    var checkBox:FlxSprite;
    public var isSel:Bool = false;
    public var curState:Bool;
    var coolText:KeyText;
    public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, ?text:String = '', ?size:Int = 8, ?isWork:Bool = false) {
        super();
        coolText = new KeyText(x, y, fieldWidth, text, size);
        coolText.font = Paths.font('3270-Regular.ttf');
        coolText.antialiasing = ClientPrefs.data.antialiasing;
        add(coolText);
        curState = isWork;
        checkBox = new FlxSprite(x, y);
        checkBox.frames = Paths.getSparrowAtlas('checkbox');
        checkBox.animation.addByPrefix('off', 'off', 1, true);
        checkBox.animation.addByPrefix('on', 'on', 1, true);
        checkBox.animation.play((isWork)? 'on' : 'off');
        checkBox.scale.set(0.065, 0.065);
        checkBox.updateHitbox();
        checkBox.antialiasing = ClientPrefs.data.antialiasing;
        add(checkBox);
        coolText.x += checkBox.x + 15;
        checkBox.y = coolText.y + (coolText.height - checkBox.height) / 2;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (isSel)
            coolText.color = 0xFFe55b22;
        else
            coolText.color = 0xFFFFFFFF;
        checkBox.animation.play((curState) ? 'on' : 'off');

        if (isSel)
            checkBox.color = 0xFFe55b22;
        else 
            checkBox.color = 0xFFffffff;
    }

    public function changeAntial()
    {
        for (sprite in members)
        {
            var sprite:FlxSprite = cast sprite;
            if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
                sprite.antialiasing = ClientPrefs.data.antialiasing;
            }
        }
    }
}

class Button extends KeyText {
    public var isState:Bool = false;
    public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, ?text:String = '', ?size:Int = 8) 
    {
        super(x, y, fieldWidth, text, size);
    }
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (isSel)
            this.color = 0xFFe55b22;
        else
            this.color = 0xFFFFFFFF;
    }
}