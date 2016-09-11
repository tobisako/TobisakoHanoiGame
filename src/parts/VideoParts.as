package parts 
{
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import ui.BackButton;
	/**
	 * ...
	 * @author tobisako
	 */
	public class VideoParts extends Video
	{
		private var conn:NetConnection;
        private var stream:NetStream;
		private var trans : SoundTransform;
		//var n:Number;

		public function VideoParts() 
		{
			conn = new NetConnection();
			conn.connect(null);
			stream = new NetStream( conn );
			stream.client = new Object();
			this.attachNetStream( stream );
			
			// ＳＥ効果音量設定オブジェクト生成
			trans = new SoundTransform();
			trans.volume = 0.5;	// ボリューム
			trans.pan = 0;		// パン
		}

		// ビデオ再生。
		public function doPlayVideo(b:Boolean):void
		{
			if (b) {
				doPlayVideoNum(0);
			} else {
				doPlayVideoNum(2);
			}
		}
		public function doPlayVideoNum(i:int):void
		{
			switch(i) {
			case 0:		stream.play("v02_800x600.mp4");		break;		// 男（せんとさん）
			case 1:		stream.play("v011_800x600.mp4");	break;		// 女（ふつう）英語
			case 2:		stream.play("v012_800x600.mp4");	break;		// 女（ふつう）ミックス
			case 3:		stream.play("v013_800x600.mp4");	break;		// 女（ふつう）日本語
			}
			stream.soundTransform = new SoundTransform( 0.5 );
		}

		// ビデオストリームの音量調整。
		public function soundTransformStream(v:uint):void
		{
			//var n:Number = new Number(　 v / 100 );
			//stream.soundTransform = new SoundTransform( n );
			trans.volume = v / 100;
			stream.soundTransform = trans;
		}
		
		// ビデオ一時停止・再開（トグル）
		public function togglePause():void {
			stream.togglePause();
		}
		
		// ビデオ一時停止
		public function pause():void {
			stream.pause();
		}
	}
}
// 参考ＵＲＬ：http://help.adobe.com/ja_JP/FlashPlatform/reference/actionscript/3/flash/media/Video.html
