package {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.text.*;
    import flash.utils.*;

    public class GamePecahBalon extends Sprite {
        private var ll:Boolean = false;
        private var FRICTION:Number = 0.95;
        public var balon:balonBanyak;
        private var arrBalon:Array;
        private var contrast:Number = 150;
        private var tempdisp:BitmapData;
        public var score:TextField;
        private var spawn:Timer;
        private var randomy:Number = 0;
        private var son:Class;
        public var lae1:MovieClip;
        public var lae2:MovieClip;
        private var randomxy:Number = 0;
        private var disp:BitmapData;
        private var randomx:Number = 0;
        private var GRAVITY:Number = 0.5;
        private var bitdisp:Bitmap;
        private var mtx:Matrix;
        private var totBol:Number = 0;
        private var skor:Number = 0;
        public var setarr:MovieClip;
        var matrix:Array;
        private var cmm:ColorMatrixFilter;
        private var timer:Timer;
        private var speed:Number = 0.2;
        private var bmp1:BitmapData;
        private var bmp2:BitmapData;
        private var cam:Camera;
        private var delays:Number = 1000;
        private var soundklik:Sound;
        private var pendeteksi:Shape;
        private var tot:int = 0;
        private var blur:BlurFilter;
        private var cm:ColorMatrixFilter;
        private var balonPantul:Boolean = true;
        private var pix1:int;
        private var pix2:int;
        private var bright:Number = 20;
        private var video:Video;
        private var pixs1:ByteArray;
        private var pixs2:ByteArray;

        public function GamePecahBalon() {
            this.matrix = new Array();
            this.pixs1 = new ByteArray();
            this.pixs2 = new ByteArray();
            this.arrBalon = new Array();
            this.timer = new Timer(5000, 1);
            this.spawn = new Timer(3000);
            this.cm = new ColorMatrixFilter();
            this.cmm = new ColorMatrixFilter();
            this.son = GamePecahBalon_son;
            this.soundklik = new Sound();
            this.prepareWebcam();
            this.soundklik = new this.son();
            this.disp = new BitmapData(640, 480, false, 0);
            this.tempdisp = new BitmapData(640, 480, false, 0);
            this.mtx = new Matrix();
            this.mtx.scale(-1, 1);
            this.mtx.translate(640, 0);
            this.bmp1 = new BitmapData(this.lae1.width, this.lae1.height, true, 0);
            this.bmp2 = new BitmapData(this.lae1.width, this.lae1.height, true, 0);
            this.matrix = this.matrix.concat([0.5, 0.5, 0.5, 0, 0]);
            this.matrix = this.matrix.concat([0.5, 0.5, 0.5, 0, 0]);
            this.matrix = this.matrix.concat([0.5, 0.5, 0.5, 0, 0]);
            this.matrix = this.matrix.concat([0, 0, 0, 1, 0]);
            this.blur = new BlurFilter();
            var _loc_1:int = 5;
            this.blur.blurY = 5;
            this.blur.blurX = _loc_1;
            this.cmm = new ColorMatrixFilter(this.matrix);
            this.pendeteksi = new Shape();
            addChild(this.pendeteksi);
            this.spawn.delay = this.delays;
            this.bitdisp = new Bitmap(this.disp);
            this.lae2.visible = false;
            this.addChild(this.lae1);
            this.addChild(this.lae2);
            this.addChild(this.balon);
            this.addChild(this.bitdisp);
            this.addChild(this.score);
            this.addChild(this.setarr);
            
			this.balon.vy = 0;
            this.balon.visible = false;
			
            this.timer.addEventListener(TimerEvent.TIMER, this.dor);
            this.timer.start();
            
			addEventListener(Event.ENTER_FRAME, this.proc);
            this.spawn.addEventListener(TimerEvent.TIMER, this.spawnBalon);
            
			return;
        }// end function

        private function jalanY(param1:Number) {
            return;
        }// end function

        private function spawnBalon(event:TimerEvent) {
            var _loc_2:Number = NaN;
            var _loc_3:MovieClip = null;
            this.randomxy = Math.ceil(Math.random() * 2);
            _loc_3 = new balonBanyak();
            _loc_3.width = 75,05;
            _loc_3.height = 120,20;
            _loc_2 = Math.floor(Math.random() * 395 + 75);    //acak balon di sumbu x
            this.arrBalon[this.totBol] = _loc_3;
            this.arrBalon[this.totBol].x = _loc_2;
            this.arrBalon[this.totBol].y = -120,20;               //posisi awal balon
            this.addChild(this .arrBalon[this.totBol]);
            this.setChildIndex(this.arrBalon[this.totBol], (this.numChildren - 1));
            this.setJalanX(this.totBol, 0.1);
            var _loc_4:* = this;
            var _loc_5:* = this.totBol + 1;
            _loc_4.totBol = _loc_5;
            return;
        }// end function

        private function setJalanX(param1:Number, param2:Number) {
            var jalanX:Function;
            var arrNum:* = param1;
            var st:* = param2;
            jalanX = function (event:Event) {
                arrBalon[arrNum].y = arrBalon[arrNum].y + speed;
                if (arrBalon[arrNum].hitTestObject(lae1) && arrBalon[arrNum].visible == true) {
                    var _loc_3:* = skor + 1;
                    skor = _loc_3;
                    soundklik.play();
                    score.text = "Balon yang pecah/hilang : " + skor;
                    arrBalon[arrNum].visible = false;
                    this.removeChild = arrBalon[arrNum];
                }
                return;
            }; // end function
            
            this.arrBalon[arrNum].addEventListener(Event.ENTER_FRAME, jalanX);
            this.speed = 2.5;
            return;
        }// end function

        private function proc(event:Event) {
            this.disp.draw(this.video, this.mtx);
            var _loc_2:* = new BitmapData(this.disp.width, this.disp.height, false, 0);
            _loc_2.draw(this.video, this.mtx);
            _loc_2.draw(this.tempdisp, null, null, BlendMode.DIFFERENCE);
            var _loc_3:uint = 10485760;
            var _loc_4:uint = 0;
            var _loc_5:uint = 16711680;
            _loc_2.applyFilter(_loc_2, _loc_2.rect, new Point(), this.cm);
            _loc_2.applyFilter(_loc_2, _loc_2.rect, new Point(), this.blur);
            _loc_2.threshold(_loc_2, _loc_2.rect, new Point(), ">", 4281545523, 4294967295);
            this.tempdisp.draw(this.video, this.mtx);
            var _loc_6:* = _loc_2.getColorBoundsRect(4294967295, 4294967295, true);
            this.pendeteksi.graphics.clear();
            this.pendeteksi.graphics.lineStyle(0, 16777215);
            this.pendeteksi.graphics.drawRect(_loc_6.x, _loc_6.y, _loc_6.width, _loc_6.height);
            if (_loc_6.x != 0 && _loc_6.y != 0) {
                this.lae1.x = _loc_6.x;
                this.lae1.y = _loc_6.y;
                this.lae1.width = _loc_6.width;
                this.lae1.height = _loc_6.height;
            }
            
			if (this.lae1.hitTestObject(this.setarr) && this.setarr.visible == true) {
                this.setarr.visible = false;
                this.spawn.start();
            }
            
			return;
        }// end function

        private function dor(event:TimerEvent) {
            this.lae1.visible = true;
            this.balon.visible = true;
            return;
        }// end function

        private function prepareWebcam() {
            this.cam = Camera.getCamera();
            this.cam.setMode(640, 480, stage.frameRate);
            this.video = new Video(640, 480);
            this.video.attachCamera(this.cam);
            return;
        }// end function
    }
}