package parts 
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
	public class MarkerParts extends CastSprite 
	{
		[Embed(source = "../img/marker.png")]
		private var Emb:Class;
		private var vy:int;
		private const ymin:int = 110;
		private const ymax:int = 120;

		/**
		 * 新しい MarkerParts インスタンスを作成します。
		 */
		public function MarkerParts( initObject:Object = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			var img:Bitmap = new Emb() as Bitmap;
			addChild( img );
			
			// アイコン動作初期化
			vy = 2;
		}

		private var bar:int;
		
		// ポジション設定めそ
		public function setPos( b:int ):void {
			bar = b;
			this.x = bar * 220 + 100 + 70;
			this.y = 110;
		}
		
		// アイコン動かしめそ（手抜き）
		public function doMoveMarker():void {
			this.y += vy
			if (this.y >= ymax) {
				vy = -2;
			} else if (this.y <= ymin) {
				vy = 2;
			}
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
	}
}