package states;
import haxe.display.FsPath;
import haxe.display.Display.Define;
import haxe.display.Display.GotoDefinitionResult;
import haxe.EnumFlags;
import backend.InputFormatter;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
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
        /*
        Array values:
        1st value - Option types = [
            name - just name, nothing more
            button - you can press it :D
            checkbox - cool yes or no
            slider - fancy looking thing that can contain muliple of buttons, will do small tween of apearing
            slider-double - same as slider, but have 2 of object fields for example framerate and vsynse options
        ]
        2nd value - Name (Just text that shows up)
        3rd value - Incode name (Thing that used in ClientPrefs) //Not needed if name type
        4th value(optional) - slider info 

        Slider info values:
        1st value(+2nd if slider-double) - Type of info = [
            bool - true or false
            string - cool names
            pracent - %
            int/float - nubers. If int without point smth, if float with
        ]
        2nd value - amound of buttons (pretty selfexplaning)
        3rd value(up to infinit) - actual buttons values
        4th value(optional) - values 
         */
        ['name', 'Preferences'],
        ['checkbox', 'Anti-Aliasing', 'antialiasing'],
        ['slider', 'Scroll Direction', 'downScroll', ['bool', 'Up', 'Down']],
        ['slider-double', 'FPS', 'framerate'. '', ['int', 'bool', 5, 30, 60, 120, 240, 'v-synce']],
        ['checkbox', 'FPS Counter', 'showFPS'],
        ['checkbox', 'Camera Zoom on Beat', 'camZooms'],
        ['checkbox', 'GPU Caching', 'cacheOnGPU'],
        ['']
    ];
    var blackBg:FlxSprite;
    var halfBlackBg:FlxSprite;
    var groupOfGroups:FlxGroup;
    var textOfSettings:FlxTypedGroup<FlxText>;
    var textOfKeys:FlxTypedGroup<KeyText>;
    var position:FlxPoint = new FlxPoint(0, 0);
    var curWidth:Float;
    var newWidth:Float;
    var coolMouse:FlxSprite;
    var changingText:FlxText;
    var pressToCancel:FlxText;
    var pressToRemove:FlxText;

    override function create()
    {
        coolMouse = new FlxSprite(0, 0).loadGraphic(Paths.image('ItStealsCursor'));
        coolMouse.antialiasing = ClientPrefs.data.antialiasing;
        coolMouse.scale.set(0.8, 0.8);

        blackBg = new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(blackBg);

        groupOfGroups = new FlxGroup();
        add(groupOfGroups);
        textOfSettings = new FlxTypedGroup();
        textOfKeys = new FlxTypedGroup();
        groupOfGroups.add(textOfSettings);
        groupOfGroups.add(textOfKeys);
        for (items in 0...keysOption.length)
        {
            switch(keysOption[items][1])
            {
                case 0:
                    position.y = 40;
                case 1:
                    position.y = 90;
                case 2:
                    position.y = 120;
                case 3:
                    position.y = 200;
                case 4:
                    position.y = 250;
                case 5:
                    position.y = 280;
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
                    position.y = 120;
                case 3:
                    position.y = 200;
                case 4:
                    position.y = 250;
                case 5:
                    position.y = 280;
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

        


        super.create();
        add(coolMouse);
    }

    var savKey:Array<Dynamic>; 
    function changeKeyBind(text:String, myId:Int) {
        for (n in 0...2)
        {
            var key:Dynamic = null;
            savKey = ClientPrefs.keyBinds.get('back');
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
            
            keyText.ID = myId;
            textOfKeys.add(keyText);
        }
    }

    var changingBut:Bool = false;
    override function update(elapsed:Float) 
    {
        if (changingBut)
        {
            halfBlackBg.alpha += elapsed * 0.9;
            changingText.alpha += elapsed * 1.8;
            pressToCancel.alpha += elapsed * 1.8;
            pressToRemove.alpha += elapsed * 1.8;
            if (halfBlackBg.alpha >= 0.5)
                halfBlackBg.alpha = 0.5;
        }
        coolMouse.x = FlxG.mouse.screenX;
        coolMouse.y = FlxG.mouse.screenY;
        super.update(elapsed);
        if (!changingBut)
        {
            textOfKeys.forEach(function(t:KeyText) {
                
                    if (FlxG.mouse.screenX >= t.x && FlxG.mouse.screenX <= t.x + t.width && FlxG.mouse.screenY >= t.y && FlxG.mouse.screenY <= t.y + t.height)
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
        else 
        {
            if (FlxG.mouse.screenX >= pressToCancel.x && FlxG.mouse.screenX <= pressToCancel.x + pressToCancel.width && FlxG.mouse.screenY >= pressToCancel.y && FlxG.mouse.screenY <= pressToCancel.y + pressToCancel.height)
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

            if (FlxG.mouse.screenX >= pressToRemove.x && FlxG.mouse.screenX <= pressToRemove.x + pressToRemove.width && FlxG.mouse.screenY >= pressToRemove.y && FlxG.mouse.screenY <= pressToRemove.y + pressToRemove.height)
            {
                pressToRemove.color = 0xFFbe0000;
                if (FlxG.mouse.justPressed)
                {
                    
                }
            }
            else 
            {
                pressToRemove.color = 0xFFbebebe;
            }
            if (FlxG.keys.justPressed.ESCAPE)
            {
                changingBut = false;
                halfBlackBg.alpha = 0;
                changingText.alpha = 0;
                pressToRemove.alpha = 0;
                pressToCancel.alpha = 0;
            }
    
            if (FlxG.keys.justPressed.BACKSPACE)
            {

            }
        }
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
}

class KeyText extends FlxText {
    public var isSel:Bool = false;
    public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, ?text:String = '', ?size:Int) 
    {
        super(x, y);
        this.x = x;
        this.y = y;
        this.fieldWidth = fieldWidth;
        this.text = text;
        this.size = size;
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