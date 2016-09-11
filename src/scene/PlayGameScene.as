package scene 
{
	// MinimalCompsとはBIT-101で提供されているGUIコンポーネントです。
	// http://www40.atwiki.jp/spellbound/pages/112.html
	import com.bit101.components.VSlider;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import jp.progression.casts.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.commands.*;
	import jp.progression.data.*;
	import jp.progression.events.*;
	import jp.progression.loader.*;
	import jp.progression.*;
	import jp.progression.scenes.*;
	import parts.VideoParts;
	import ui.BackButton;
	import ui.ClearButton;
	import pages.GameFieldBG;
	import parts.L5Parts;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.media.Sound;
	import parts.MarkerParts;
	import ui.OmakeButton;

	/**
	 * ...
	 * @author tobisako
	 */
	public class PlayGameScene extends SceneObject 
	{
		[Embed(source = "../img/sentokun.png")] private var sento:Class;
		[Embed(source = "../img/btn_pause.jpg")] private var pauseimg:Class;
		[Embed(source = "../img/timeover.png")] private var etimeover:Class;
		[Embed(source = "../se/se_up.mp3")] private static const EmbS1:Class;
		[Embed(source = "../se/se_down.mp3")] private var EmbS2:Class;
		[Embed(source = "../se/se_ng.mp3")] private var EmbS3:Class;
		[Embed(source = "../se/se_clear.mp3")] private var EmbS4:Class;
		[Embed(source = "../se/se_shot.mp3")] private var EmbS5:Class;
		[Embed(source = "../se/se_hoissuru.mp3")] private var EmbS6:Class;

		private var bOtokoMode:Boolean;
		private const MAX_BAR:int = 3;
		private const MAX_LENGTH:int = 5+1;
		private var cnt:int;
		private var fcnt:int;
		private var bMovPause:Boolean;		// 非連動（ださい）
		private var debugtext:TextField;
		private var ftext:TextField;
		private var txt:TextField;
		private var gameFieldBG:GameFieldBG;
		private var clearButton:ClearButton;
		private var l5Parts:L5Parts;
		private var l4Parts:L5Parts;
		private var l3Parts:L5Parts;
		private var l2Parts:L5Parts;
		private var l1Parts:L5Parts;
		private var mark1:MarkerParts;
		private var mark2:MarkerParts;
		private var mark3:MarkerParts;
		private var bMarkerView:Boolean;
		private var bGameClear:Boolean;
		private var bGameOver:Boolean;
		private var bar : Array = [
			[null, null, null, null, null, null],
			[null, null, null, null, null, null],
			[null, null, null, null, null, null]
		];
		private var se01:Sound;
		private var se02:Sound;
		private var se03:Sound;
		private var se04:Sound;
		private var se05:Sound;
		private var se06:Sound;
		private var vp:VideoParts;
		private var sls1:Sprite;
		private var slb1:VSlider;
		private var sls2:Sprite;
		private var slb2:VSlider;
		private var trans : SoundTransform;
		private var sentoimg:Sprite;
		private var pausebtn:Sprite;
		private var timeover:Sprite;
		private var backbtn:BackButton;
		private var omakebtn:OmakeButton;

		/**
		 * 新しい PlayGameScene インスタンスを作成します。
		 */
		public function PlayGameScene( name:String = null, initObject:Object = null ) 
		{
			// 親クラスを初期化する
			super( name, initObject );
			
			// シーンタイトルを設定します。
			title = "title";

			// このシーンのＢＧ画像を追加
			gameFieldBG = new GameFieldBG();
			
			// 漢モードチェックボックス
			bOtokoMode = false;

			// れりごービデオを作成
			vp = new VideoParts();

			// れりごー音量スライダーを作成
			sls1 = new Sprite();
			slb1 = new VSlider(sls1, 0, 0, onChange1);
			sls1.addChild(slb1);
			slb1.value = 50;
			sls1.y = 100;

			// ＳＥ効果音スライダーを作成
			sls2 = new Sprite();
			slb2 = new VSlider(sls2, 0, 0, onChange2);
			sls2.addChild(slb2);
			slb2.value = 50;
			sls2.x = 40;
			sls2.y = 100;
			
			// ＳＥ効果音量設定オブジェクト生成
			trans = new SoundTransform();
			trans.volume = 0.5;	// ボリューム
			trans.pan = 0;		// パン

			// ハノイパーツを生成
			l5Parts = new L5Parts(5);
			l5Parts.setMoveStopCallback(func01);

			l4Parts = new L5Parts(4);
			l4Parts.setMoveStopCallback(func01);

			l3Parts = new L5Parts(3);
			l3Parts.setMoveStopCallback(func01);

			l2Parts = new L5Parts(2);
			l2Parts.setMoveStopCallback(func01);

			l1Parts = new L5Parts(1);
			l1Parts.setMoveStopCallback(func01);

			// バー選択用マーカー作成
			mark1 = new MarkerParts();
			mark1.setPos(0);
			mark2 = new MarkerParts();
			mark2.setPos(1);
			mark3 = new MarkerParts();
			mark3.setPos(2);
			
			// ゲームクリアボタンを追加
			clearButton = new ClearButton();

			// 案内用テキストフィールド
			txt = new TextField();
			txt.mouseEnabled = false;
			var format:TextFormat = new TextFormat();
			format.size = 24;
			txt.defaultTextFormat = format;
			txt.text = "ほげほげ";
			txt.width = 700;
			txt.x = 100;
			txt.y = 20;

			// 効果音１
			se01 = new EmbS1() as Sound;
			se02 = new EmbS2() as Sound;
			se03 = new EmbS3() as Sound;
			se04 = new EmbS4() as Sound;
			se05 = new EmbS5() as Sound;
			se06 = new EmbS6() as Sound;

			// せんとくんスプライト
			sentoimg = new Sprite();
			sentoimg.x = 700;
			sentoimg.y = 120;
			
			// タイムアウト画像
			timeover = new Sprite();
			timeover.addChild( new etimeover() as Bitmap );

			// ビデオ一時停止ボタン
			pausebtn = new Sprite();
			pausebtn.addChild( new pauseimg() as Bitmap );
			pausebtn.x = 10;
			pausebtn.y = 260;
			
			// 「戻る」ボタン
			backbtn = new BackButton();
			backbtn.visible = true;
			backbtn.x = 0;
			backbtn.y = 530;
			
			// 「おまけ」ボタン
			omakebtn = new OmakeButton();

			// デバッグ用フレームレート表示テキストエリア
			ftext = new TextField();
			ftext.mouseEnabled = false;
			ftext.text = "";
			ftext.width = 300;
			ftext.x = 10;
			ftext.y = 230;

			// デバッグ用テキストフィールド
			debugtext = new TextField();
			debugtext.mouseEnabled = false;
			debugtext.text = "ほげぴよ";
			debugtext.width = 300;
			debugtext.x = 10;
			debugtext.y = 10;

			// SCENE_INIT_COMPLETE時のコールバック登録
			this.addEventListener(SceneEvent.SCENE_INIT_COMPLETE, atSceneInitComplete);
		}
		
		// 「漢モード」チェックボックス状態をセット・保持。
		public function setOtokoMode(b:Boolean):void {
			bOtokoMode = b;
		}

		// ブロックが移動停止した際に呼び出されるコールバック
		private function func01(b:Boolean, o:L5Parts):void {
			if (b) {	// 空中で停止
				se01.play(0, 0, trans);
			} else {	// 地上に着地
				se02.play(0, 0, trans);
				buruburuParts(o.getBar());	// 該当全員ブルブルさせる
			}
			//vp.togglePause();	// ビデオ一時停止テスト
			//http://help.adobe.com/ja_JP/ActionScript/3.0_ProgrammingAS3/WS5b3ccc516d4fbf351e63e3d118a9b90204-7d4d.html
		}
		
		// 着地時に関連ブロック全部をブルブルさせる処理
		private function buruburuParts(p:int):void {
			for (var y:int = 1; y < MAX_LENGTH; y++) {
				if (bar[p][y] != null)　 {
					bar[p][y].startVib();	// ぶるぶるさせる
				}
			}
		}

		// SCENE_INIT_COMPLETEコールバック
		private function atSceneInitComplete(event:Event):void 
		{
			// ゲーム初期化
			for (var x:int = 0; x < MAX_BAR; x++) {
				for (var y:int = 0; y < MAX_LENGTH; y++) {
					bar[x][y] = null;
				}
			}
			l5Parts.setPos(0, 5);
			l5Parts.setOtokoMode(bOtokoMode);
			bar[0][5] = l5Parts;
			l4Parts.setPos(0, 4);
			l4Parts.setOtokoMode(bOtokoMode);
			bar[0][4] = l4Parts;
			l3Parts.setPos(0, 3);
			l3Parts.setOtokoMode(bOtokoMode);
			bar[0][3] = l3Parts;
			l2Parts.setPos(0, 2);
			l2Parts.setOtokoMode(bOtokoMode);
			bar[0][2] = l2Parts;
			l1Parts.setPos(0, 1);
			l1Parts.setOtokoMode(bOtokoMode);
			bar[0][1] = l1Parts;
			stage.frameRate = 24;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			cnt = 0;
			bGameClear = false;
			bGameOver = false;
			debugtext.text = "READY!";

			// バー選択用マーカー初期化
			bMarkerView = false;
			mark1.visible = false;
			mark2.visible = false;
			mark3.visible = false;

			// ゲームクリアボタンの初期化
			clearButton.visible = false;
			clearButton.x = 220;
			clearButton.y = 70;

			// タイムアウト画面の初期化
			timeover.x = 80;
			timeover.y = 50;
			timeover.visible = false;

			// オマケボタン初期化
			omakebtn.visible = false;	// ここからオマケ画面へ遷移すると処理がずれる
			omakebtn.x = 680;
			omakebtn.y = 510;

			// ポーズボタン押下イベントを登録する
			pausebtn.addEventListener(MouseEvent.CLICK, onPauseBtn);
			
			// パーツにリスナーを登録する。
			l1Parts.addEventListener(MouseEvent.CLICK, onClick1);
			l2Parts.addEventListener(MouseEvent.CLICK, onClick2);
			l3Parts.addEventListener(MouseEvent.CLICK, onClick3);
			l4Parts.addEventListener(MouseEvent.CLICK, onClick4);
			l5Parts.addEventListener(MouseEvent.CLICK, onClick5);

			// マーカーにリスナーを登録する。
			mark1.addEventListener(MouseEvent.CLICK, onClickM1);
			mark2.addEventListener(MouseEvent.CLICK, onClickM2);
			mark3.addEventListener(MouseEvent.CLICK, onClickM3);

			// ムービー再生開始
			vp.width = 400;		// 800;
			vp.height = 300;	// 600;
			vp.x = 200;
			vp.y = 80;
			vp.doPlayVideo( bOtokoMode );
			fcnt = 0;
			bMovPause = false;

			// せんとくん挿入
			if(bOtokoMode) {
				var img:Bitmap = new sento() as Bitmap;
				sentoimg.addChild(img);
			}

			// ガイドメッセージ表示
			setGuideMessage();
		}

		// ポーズボタン押下時コールバック
		private function onPauseBtn(event:Event):void
		{
			vp.togglePause();	// ビデオ一時停止テスト
			bMovPause = (bMovPause) ? false : true;
		}

		// スライダー操作時イベント（れりごー）
		private function onChange1(event:Event):void
		{
			vp.soundTransformStream(event.currentTarget.value);
		}

		// スライダー操作時イベント（ＳＥ効果音）
		private function onChange2(event:Event):void
		{
			trans.volume = new Number( event.currentTarget.value / 100 );
		}

		// ガイドメッセージ表示
		private function setGuideMessage():void {
			debugtext.text　 = "回数=" + cnt;
			if (bGameClear) {
				txt.text = "ゲームクリア！おめでとう！（ブロックを動かした回数＝" + cnt + ")";
				return;
			}
			if (bMarkerView) {
				txt.text = "現われたマーカーをクリックして、ブロックを積んでね！";
			} else {
				txt.text = "ブロックをクリックして、空中に浮かべてね！";
			}
		}
		// パーツ１がクリックされた
		private function onClick1(event:Event):void
		{
			if(l1Parts.isNotMove()) moveClickParts( l1Parts );
		}
		// パーツ2がクリックされた
		private function onClick2(event:Event):void
		{
			if(l2Parts.isNotMove()) moveClickParts( l2Parts );
		}
		// パーツ3がクリックされた
		private function onClick3(event:Event):void
		{
			if(l3Parts.isNotMove()) moveClickParts( l3Parts );
		}
		// パーツ4がクリックされた
		private function onClick4(event:Event):void
		{
			if(l4Parts.isNotMove()) moveClickParts( l4Parts );
		}
		// パーツ5がクリックされた
		private function onClick5(event:Event):void
		{
			if(l5Parts.isNotMove()) moveClickParts( l5Parts );
		}
		// マーカー１がクリックされた
		private function onClickM1(event:Event):void
		{
			if(getFloatParts().isNotMove()) moveClickParts( getFloatParts(), 0 );
		}
		// マーカー2がクリックされた
		private function onClickM2(event:Event):void
		{
			if(getFloatParts().isNotMove()) moveClickParts( getFloatParts(), 1 );
		}
		// マーカー3がクリックされた
		private function onClickM3(event:Event):void
		{
			if(getFloatParts().isNotMove()) moveClickParts( getFloatParts(), 2 );
		}

		// 空中に浮いているパーツを返す
		private function getFloatParts():L5Parts
		{
			for (var x:int = 0; x < MAX_BAR; x++) {
				if (bar[x][0] != null) {
					return bar[x][0];	// 発見！
				}
			}
			return null;	// 失敗
		}

		// パーツを動かす（true=成功、false=失敗）
		private function moveClickParts(p:L5Parts, dx:int = -1):Boolean
		{
			var sx:int = p.getBar();	// 移動元ブロックのＸ座標（SourceX)を算出する
			var sy:int = p.getPos();	// 移動元ブロックのＹ座標（SourceY）を算出する
			if (dx == -1) {
				dx = sx;	// 移動先バーの指定が無い場合は、ブロックと同じ座標とする。
			}

			// 自分がどこにいるのかを探す
			if (bar[sx][sy] == p) {
				// 配列のどこに居るかチェックする
				//debugtext.text = "HAKKEN! sx=" + sx + ", sy=" + sy;
				if ( sy == 0 ) {	// 空中に浮いている。
					// 着地できるか判定する
					for (var dy:int = 1; dy < MAX_LENGTH; dy++) {
						if (bar[dx][dy] != null)　 {
							if ((bar[dx][dy]).getLelel() > p.getLelel()) {
								// 自分より大きいブロックが下にいた：上に乗ってＯＫ！
								moveParts(p, false, sx, 0, dx, dy - 1);
								return true;
							}
							se03.play(0, 0, trans);
							return false;	// 移動できず。
						}
					}
					// 最後までnullだった：一番下に着地させてもＯＫ！
					moveParts(p, false, sx, 0, dx, MAX_LENGTH - 1);
					return true;
				} else {		// 棒に刺さっている。
					// 空中に浮けるかどうかをチェック：他に浮いているやつは居るか？
					if (getFloatParts() == null) {
						// 自分の上にピースいないか？
						if (bar[sx][sy - 1] == null) {
							// 自分の上には誰も居ない：ピースを空中に浮かせる。
							moveParts(p, true, sx, sy, sx, 0);	// 浮くときは、真上に浮く。
							return true;
						}
					}
					se03.play(0, 0, trans);
					return false;	// 他に空中浮いてるブロックあったら、ダメって事にする（簡略化の為）
				}
			} else {
				debugtext.text = "FATAL:NO PARTS FOUND!";
			}
			se03.play(0, 0, trans);
			return false;	// 異常系終了
		}

		// パーツを動かす（空中に浮かせたり、着地させたり。）
		private function moveParts(p:L5Parts, bJump:Boolean, sx:int, sy:int, dx:int, dy:int):void
		{
			//debugtext.text = "move! 1";
			if (bJump) {	// 地面→空中へ。
				bar[dx][0] = p;
				p.movePos(dx, 0);
				dispMarker(bJump, (bOtokoMode) ? p : null );	// マーカー表示する。
				se05.play(0, 0, trans);
			} else {		// 空中→地面へ。
				bar[dx][dy] = p;
				p.movePos(dx, dy);
				dispMarker(bJump);	// マーカーを消す。
				if (sx != dx) {
					cnt++;	// ブロックを別のレーンへ移動させた時だけ、回数を増やす。
				}
				se05.play(0, 0, trans);
				if (bar[2][1] != null) {
					// ゲームクリア！！
					if ( bGameClear == false ) {
						clearButton.visible = true;
						se04.play();
						bGameClear = true;
					}
				}
			}
			bar[sx][sy] = null;
			bMarkerView = bJump;
			setGuideMessage();		// ガイドメッセージ更新
		}

		// ３本のバー・マーカー表示
		private function dispMarker(bEnable:Boolean, p:L5Parts = null):void
		{
			if (bEnable) {	// マーカーを表示する
				if(p == null || (p != null && p.getBar() != 0)) mark1.visible = true;
				if(p == null || (p != null && p.getBar() != 1)) mark2.visible = true;
				if(p == null || (p != null && p.getBar() != 2)) mark3.visible = true;
			} else {		// 消去する
				mark1.visible = false;
				mark2.visible = false;
				mark3.visible = false;
			}
		}

		// フレーム・コールバック
		private function onEnterFrame(event:Event):void 
		{
			if (bMovPause == false) fcnt++;
			ftext.text = "fcnt=" + fcnt;
			
			// 所定のフレームまで来たらタイムアップとする。
			if(!bGameClear && !bGameOver) {
				var ftmp:int = (bOtokoMode) ? 5340 : 5250;	// せんとさん　：　ふつう
				if ( fcnt > ftmp ) {// タイムオーバー
					vp.pause();					// ビデオ停止
					timeover.visible = true;	// タイムオーバー表示。
					se06.play();				// ホイッスル音
					bGameOver = true;
				}
			}

			// パーツアニメーション
			l1Parts.doMoveParts();
			l2Parts.doMoveParts();
			l3Parts.doMoveParts();
			l4Parts.doMoveParts();
			l5Parts.doMoveParts();

			// マーカーアニメーション
			if(bMarkerView) {
				mark1.doMoveMarker();
				mark2.doMoveMarker();
				mark3.doMoveMarker();
			}
		}

		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void 
		{
			addCommand(
				new AddChild( container , gameFieldBG ),
				new AddChild( container , vp ),
				new AddChild( container , debugtext ),
				new AddChild( container , ftext ),
				new AddChild( container , txt ),
				new AddChild( container , pausebtn ),
				new AddChild( container , l5Parts ),
				new AddChild( container , l4Parts ),
				new AddChild( container , l3Parts ),
				new AddChild( container , l2Parts ),
				new AddChild( container , l1Parts ),
				new AddChild( container , mark1 ),
				new AddChild( container , mark2 ),
				new AddChild( container , mark3 ),
				new AddChild( container , sls1 ),
				new AddChild( container , sls2 ),
				new AddChild( container , sentoimg ),
				new AddChild( container , timeover ),
				new AddChild( container , backbtn ),
				new AddChild( container , omakebtn ),
				new AddChild( container , clearButton )
			);
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void 
		{
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void 
		{
			vp.pause();
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
			addCommand(
				new RemoveChild( container , gameFieldBG ),
				new RemoveChild( container , vp ),
				new RemoveChild( container , debugtext ),
				new RemoveChild( container , ftext ),
				new RemoveChild( container , txt ),
				new RemoveChild( container , pausebtn ),
				new RemoveChild( container , l5Parts ),
				new RemoveChild( container , l4Parts ),
				new RemoveChild( container , l3Parts ),
				new RemoveChild( container , l2Parts ),
				new RemoveChild( container , l1Parts ),
				new RemoveChild( container , mark1 ),
				new RemoveChild( container , mark2 ),
				new RemoveChild( container , mark3 ),
				new RemoveChild( container , sls1 ),
				new RemoveChild( container , sls2 ),
				new RemoveChild( container , sentoimg ),
				new RemoveChild( container , timeover ),
				new RemoveChild( container , backbtn ),
				new RemoveChild( container , omakebtn ),
				new RemoveChild( container , clearButton )
			);
		}
	}
}
