package scene {
	import com.bit101.components.CheckBox;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
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
	import jp.progression.executors.*;
	import jp.progression.scenes.*;
	import ui.OmakeButton;
	import ui.StartButton;
	import pages.TitleBG;
	import scene.IndexScene;
	import scene.PlayGameScene;

	/**
	 * ...
	 * @author tobisako
	 */
	public class IndexScene extends SceneObject 
	{
		private var titleBG:TitleBG;
		private var playGameScene:PlayGameScene;
		private var debugScene:DebugScene;
		private var startButton:StartButton;
		private var checks:Sprite;
		private var check1:CheckBox;
		// 妙なＳＥセット
		// http://www.vita-chi.net/sec/voi/hora/voivoi1.htm
		[Embed(source = "../img/titlelogo.png")] private var eg:Class;
		[Embed(source = "../img/yukkuri.png")] private var ey:Class;
		[Embed(source = "../se/bgm_nc97718.mp3")] private static const eb01:Class;
		[Embed(source = "../se/se_click.mp3")] private static const es01:Class;
		[Embed(source = "../se/se_nandakore.mp3")] private static const es02:Class;
		[Embed(source = "../se/se_kuso.mp3")] private static const es03:Class;
		[Embed(source = "../se/se_yamero.mp3")] private static const es04:Class;
		[Embed(source = "../se/se_himei.mp3")] private static const es05:Class;
		[Embed(source = "../se/se_tettette.mp3")] private static const es06:Class;
		private var bgm01:Sound;
		private var se01:Sound;
		private var se02:Sound;
		private var se03:Sound;
		private var se04:Sound;
		private var se05:Sound;
		private var se06:Sound;
		private var sch:SoundChannel;
		private var logo:Sprite;
		private var cnt:int;
		private var yukkuri:Sprite;
		private var omakebtn:OmakeButton;

		/**
		 * 新しい IndexScene インスタンスを作成します。
		 */
		public function IndexScene() 
		{
			// シーンタイトルを設定します。
			title = "HanoiGame";

			// このシーンのＳＥを追加
			bgm01 = new eb01() as Sound;
			se01 = new es01() as Sound;
			se02 = new es02() as Sound;
			se03 = new es03() as Sound;
			se04 = new es04() as Sound;
			se05 = new es05() as Sound;
			se06 = new es06() as Sound;
			cnt = 0;

			// このシーンのＢＧ画像を追加
			titleBG = new TitleBG();
			//addChild( titleBG );
			
			// 「漢モード」チェック
			checks = new Sprite();
			check1 = new CheckBox(checks, 650, 480, "OTOKO MODE", onCheckBox);
			checks.addChild(check1);
			
			// ゆっくりアイコン追加
			yukkuri = new Sprite();
			yukkuri.addChild( new ey() as Bitmap );
			yukkuri.x = 360;
			yukkuri.y = 500;
			yukkuri.alpha = 50;

			// 「おまけ」ボタン
			omakebtn = new OmakeButton();
			omakebtn.visible = true;
			omakebtn.x = 680;
			omakebtn.y = 510;

			// 「ハノイの塔」ロゴ
			//　ジェネレーター：http://sngk.net/
			logo = new Sprite();
			var img:Bitmap = new eg() as Bitmap;
			logo.addChild(img);
			logo.x = 80;

			// 子シーン追加
			playGameScene = new PlayGameScene();
			playGameScene.name = "playgame";
			addScene( playGameScene );

			// 子シーン追加
			debugScene = new DebugScene();
			debugScene.name = "debug";
			addScene( debugScene );

			// ゲームスタートボタンを追加
			startButton = new StartButton();
			startButton.x = 100;
			startButton.y = 300;

			// SCENE_INIT_COMPLETE時のコールバック登録
			this.addEventListener(SceneEvent.SCENE_INIT_COMPLETE, atSceneInitComplete);
		}

		// SCENE_INIT_COMPLETEコールバック
		private function atSceneInitComplete(event:Event):void 
		{
			var trans : SoundTransform;
			trans = new SoundTransform();
			trans.volume = 0.1;	// ボリューム
			trans.pan = 0;		// パン
			sch = bgm01.play(0, 999, trans);
			
			// ゆっくりボタン押下イベントを登録する
			yukkuri.addEventListener(MouseEvent.CLICK, onYukkuriBtn);
		}

		// ゆっくりを押した時のコールバック
		private function onYukkuriBtn(event:MouseEvent):void {
			se06.play();
		}

		// チェックボックスを押した時のコールバック
		private function onCheckBox(event:MouseEvent):void {
			playGameScene.setOtokoMode( event.currentTarget.selected );
			se01.play();
			if ( event.currentTarget.selected ) {
				switch(cnt) {
				case 0:		se02.play();	break;
				case 1:		se03.play();	break;
				case 2:		se04.play();	break;
				default:	se05.play();	break;
				}
				cnt++;
			}
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void 
		{
			addCommand(
				new AddChild( container , titleBG ),
				new AddChild( container , logo ),
				new AddChild( container , startButton ),
				new AddChild( container , yukkuri ),
				new AddChild( container , omakebtn ),
				new AddChild( container , check1 )
			);
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void 
		{
			addCommand(
			);
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void 
		{
			sch.stop();		// てってってー停止

			addCommand(
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
			addCommand(
				new RemoveChild( container , titleBG ),
				new RemoveChild( container , logo ),
				new RemoveChild( container , startButton ),
				new RemoveChild( container , yukkuri ),
				new RemoveChild( container , omakebtn ),
				new RemoveChild( container , check1 )
			);
		}
	}
}
