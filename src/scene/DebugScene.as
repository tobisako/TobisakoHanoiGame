package scene 
{
	import flash.events.Event;
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
	import pages.TitleBG;
	import parts.VideoParts;
	import ui.BackButton;
	
	/**
	 * ...
	 * @author tobisako
	 */
	public class DebugScene extends SceneObject 
	{
		private var titleBG:TitleBG;
		private var vp1:VideoParts;
		private var vp2:VideoParts;
		private var vp3:VideoParts;
		private var vp4:VideoParts;
		private var f:int;
		private var backbtn:BackButton;

		/**
		 * 新しい DebugScene インスタンスを作成します。
		 */
		public function DebugScene( name:String = null, initObject:Object = null ) 
		{
			// 親クラスを初期化する
			super( name, initObject );
			
			// シーンタイトルを設定します。
			title = "title";
			
			// このシーンのＢＧ画像を追加
			titleBG = new TitleBG();

			// れりごービデオを作成
			//vp1 = new VideoParts();
			vp2 = new VideoParts();
			vp3 = new VideoParts();
			//vp4 = new VideoParts();
			
			// 戻るボタンテスト
			backbtn = new BackButton();
			backbtn.visible = false;
			backbtn.x = 0;
			backbtn.y = 540;
			
			// SCENE_INIT_COMPLETE時のコールバック登録
			this.addEventListener(SceneEvent.SCENE_INIT_COMPLETE, atSceneInitComplete);
		}
		
		// SCENE_INIT_COMPLETEコールバック
		private function atSceneInitComplete(event:Event):void 
		{
			// フレームコールバック登録
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			f = 0;
/*
			// ムービー再生開始
			vp1.width = 400;		// 800;
			vp1.height = 300;	// 600;
			vp1.x = 0;
			vp1.y = 0;
			vp1.doPlayVideoNum( 1 );
			vp1.togglePause();
*/

			vp2.width = 400;		// 800;
			vp2.height = 300;	// 600;
			vp2.x = 400;
			vp2.y = 0;
			vp2.doPlayVideoNum( 2 );
			vp2.togglePause();

			vp3.width = 400;		// 800;
			vp3.height = 300;	// 600;
			vp3.x = 0;
			vp3.y = 300;
			vp3.doPlayVideoNum( 0 );
			vp3.togglePause();
/*
			vp4.width = 400;		// 800;
			vp4.height = 300;	// 600;
			vp4.x = 400;
			vp4.y = 300;
			vp4.doPlayVideoNum( 3 );
			vp4.togglePause();
*/			
		}

		// フレーム・コールバック
		private function onEnterFrame(event:Event):void 
		{
			f++;
			//if (f == 13) vp1.togglePause();
			if (f == 1) vp2.togglePause();
			if ( f == 44) vp3.togglePause();	// せんとさん
			//if ( f == 30) vp4.togglePause();
			if( f == 240) backbtn.visible = true;
		}

		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void 
		{
			addCommand(
				new AddChild( container , titleBG ),
				//new AddChild( container , vp1 ),
				new AddChild( container , vp2 ),
				new AddChild( container , vp3 ),
				//new AddChild( container , vp4 ),
				new AddChild( container , backbtn )
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
			vp1.pause();
			vp2.pause();
			vp3.pause();
			vp4.pause();
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
			addCommand(
				new RemoveChild( container , titleBG ),
				//new RemoveChild( container , vp1 ),
				new RemoveChild( container , vp2 ),
				new RemoveChild( container , vp3 ),
				//new RemoveChild( container , vp4 ),
				new RemoveChild( container , backbtn )
			);
		}
	}
}