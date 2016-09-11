package ui 
{
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
	import jp.progression.scenes.*;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author tobisako
	 */
	public class ClearButton extends CastButton 
	{
		[Embed(source = "../img/btn_clear.png")]
		private var Emb:Class;
		
		/**
		 * 新しい ClearButton インスタンスを作成します。
		 */
		public function ClearButton( initObject:Object = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			
			// 移動先となるシーン識別子を設定します。
			//sceneId = new SceneId( "/index" );
			
			// 外部リンクの場合には href プロパティに設定します。
			href = "https://www.youtube.com/watch?v=gqY-t0la2q4&amp;amp;list=PLuXL6NS58Dyztg3TS-kJVp58ziTo5Eeck&amp;amp;index=16";
			
			var img:Bitmap = new Emb() as Bitmap;
			addChild( img );
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void 
		{
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRemoved():void 
		{
		}
		
		/**
		 * Flash Player ウィンドウの CastButton インスタンスの上でユーザーがポインティングデバイスのボタンを押すと送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastMouseDown():void 
		{
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastMouseUp():void 
		{
		}
		
		/**
		 * ユーザーが CastButton インスタンスにポインティングデバイスを合わせたときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRollOver():void 
		{
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRollOut():void 
		{
		}
	}
}