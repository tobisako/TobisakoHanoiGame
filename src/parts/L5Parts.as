package parts 
{
	import jp.nium.impls.ITextField;
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
	public class L5Parts extends CastSprite 
	{
		private var lv:int;
		[Embed(source = "../img/logo5.jpg")]
		private var Emb5:Class;
		[Embed(source = "../img/logo4.jpg")]
		private var Emb4:Class;
		[Embed(source = "../img/logo3.jpg")]
		private var Emb3:Class;
		[Embed(source = "../img/logo2.jpg")]
		private var Emb2:Class;
		[Embed(source = "../img/logo1.jpg")]
		private var Emb1:Class;
		private var isNotMoving:Boolean;
		private var isVib:Boolean;			// 振動モード
		private var dx:int;
		private var dy:int;
		private var vx:int;
		private var vy:int;
		private var px:int;
		private var py:int;
		private var vibcnt:int;
		private var fx:int;	// 空中浮遊楕円軌道
		private var fy:int;	// 空中浮遊楕円軌道
		private var r:Number;	// 半径
		private var rd:Number;	// 角度
		private var bOtokoMode:Boolean;		// 男モード
		private var fcnt:int;				// フレームカウント保持

		/**
		 * 新しい L5Parts インスタンスを作成します。
		 */
		public function L5Parts( num:int = 1, initObject:Object = null ) 
		{
			lv = num;
			isNotMoving = true;
			r = new Number();
			rd = new Number();

			// 親クラスを初期化します。
			super( initObject );

			var img:Bitmap;
			switch(lv) {
			case 5:		img = new Emb5() as Bitmap;		break;
			case 4:		img = new Emb4() as Bitmap;		break;
			case 3:		img = new Emb3() as Bitmap;		break;
			case 2:		img = new Emb2() as Bitmap;		break;
			case 1:
			default:
						img = new Emb1() as Bitmap;		break;
			}
			addChild( img );
		}

		// 男モード登録
		public function setOtokoMode(b:Boolean):void {
			bOtokoMode = b;
			fcnt = 0;		// ここでフレームカウント初期化（手抜きすぎｒ）
		}

		//　ブロックが停止した際のコールバック関数を登録する
		// http://n2works.net/column/pickup/id/21
		private var func01:Function;
		public function setMoveStopCallback(f:Function):void {
			func01 = f;
		}

		// ブロック振動指令
		public function startVib():void {
			isVib = true;
			vibcnt = 20;	// 20フレームぶるぶるする
			px = this.x;
			py = this.y;
		}

		// アイコン動かしめそ（手抜き）
		public function doMoveParts():void {
			fcnt++;		//　フレームカウント増加
			// ブロック振動処理
			if (isVib) {
				this.x = px + (Math.random() * 7) - 3;
				this.y = py + (Math.random() * 3) - 1;
				vibcnt--;
				if (vibcnt <= 0) {
					this.x = px;	// リストア。
					this.y = py;	// ポップ。
					isVib = false;	// 振動モード終了
				}
			}

			// ブロック移動処理
			if (isNotMoving) {
				// ブロック停止中
				if (pos == 0) {	// 空中で停止している時
					// ブロックに「楕円軌道」を描かせる
					// http://gihyo.jp/dev/serial/01/as3/0016
					this.x += Math.cos(rd) * r;
					this.y += Math.sin(rd) * (r / 2);
					// 軌道移動速度を変える
					if (bOtokoMode) {	// 男モード
						rd = (rd > 359) ? 0 : rd + 0.4;		// ２倍の速度で回る
						r = (r > 40 + (fcnt / 200)) ? r : r + 0.4;			// ２倍の速度で１．３倍の距離＋まで度で半径が広がる＋
					} else {			// ノーマルモード
						rd = (rd > 359) ? 0 : rd + 0.2;
						r = (r > 30) ? r : r + 0.2;
					}
				}
			}　else {
				// ブロック空中移動中
				if (vx > 0) {
					this.x += vx;
					vx *= 2;
					if (this.x >= dx) {
						this.x = dx;
						vx = 0;
					}
				} else if (vx < 0) {
					this.x += vx;
					vx *= 2;
					if (this.x <= dx) {
						this.x = dx;
						vx = 0;
					}
				} else if (vy > 0) {
					this.y += vy;
					vy *= 2;
					if (this.y >= dy) {
						this.y = dy;
						vy = 0;
						isNotMoving = true;		// 停止した！（地面に着地した！）
						isVib = false;			// 異常動作を防ぐため
						if (func01 != null) func01(false, this);	// コールバック発動
						//startVib();		// ぶるぶる震えるモードに突入
					}
				}　else if (vy < 0) {
					this.y += vy;
					vy *= 2;
					if (this.y <= dy) {
						this.y = dy;
						vy = 0;
						isNotMoving = true;		// 停止した！（空中にで停止した！）
						isVib = false;			// 異常動作を防ぐため
						if (func01 != null) func01(true, this);	// コールバック発動
						// 空中で楕円軌道を描くモードに突入
						fx = this.x;
						fy = this.y;
						r = 2;
						rd = 0;
					}
				}
			}
		}

		private var bar:int;
		private var pos:int;

		// ポジション設定めそ（強制移動）
		public function setPos( b:int, p:int ):void {
			this.x = calcDistX(b);
			this.y = calcDistY(p);
		}

		// ポジション移動めそ（新・ムーブ機能）
		public function movePos( b:int, p:int ):void {
			if (isNotMoving == false) return;
			isNotMoving = false;
			dx = calcDistX(b);
			vx = (this.x > dx) ? -2 : 2;
			dy = calcDistY(p);
			vy = (this.y > dy) ? -2 : 2;
		}

		// 目的地座標計算Ｘ
		public function calcDistX(b:int):int {
			bar = b;
			return b * 220 + 100 + ( (5 - lv) * 15);
		}

		// 目的地座標計算Ｙ
		public function calcDistY(p:int):int {
			var dy:int;
			pos = p;
			if (p == 0) {
				dy = 50;
			} else {
				dy = p * 50 + 200;
			}
			return dy;
		}
		
		// ブロックが移動中じゃないかどうかを返す
		public function isNotMove():Boolean {
			return isNotMoving;
		}
		
		// ブロックのレベル調査めそ
		public function getLelel():int {
			return lv;
		}
		
		// ブロックのバー位置調査めそ
		public function getBar():int {
			return bar;
		}
		
		// ブロックの高さ位置調査めそ
		public function getPos():int {
			return pos;
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