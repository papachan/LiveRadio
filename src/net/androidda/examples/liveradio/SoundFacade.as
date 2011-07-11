package net.androidda.examples.liveradio
{
	import com.mauft.OggLibrary.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	public class SoundFacade extends EventDispatcher
	{
	
		public var autoPlay:Boolean = true;
		private var soundBytesTotal:Number;
		public var progressInterval:int = 1000;
		public var isPlaying:Boolean = false;
		public var bufferTime:int = 1000;
		public var oggDecoder:OggRadio;
		public var recordStream:URLStream;
		public var autoLoad:Boolean = true;
		public var pausePosition:int = 0;
		private var soundBytesLoaded:Number;
		public var isReadyToPlay:Boolean = false;
		public var sc:SoundChannel;
		public var isLoaded:Boolean = false;
		public var isStreaming:Boolean = true;
		public var isRecording:Boolean = false;
		public var url:String;
		public var playTimer:Timer;
		public var s:Sound;
		public static const PLAY_PROGRESS:String = "playProgress";
		
		public function SoundFacade(soundUrl:String, autoLoad:Boolean = true, autoPlay:Boolean = true, streaming:Boolean = true, bufferTime:int = -1)
		{
			this.url = soundUrl;
			this.autoLoad = autoLoad;
			this.autoPlay = autoPlay;
			this.isStreaming = streaming;
			if(bufferTime<0){
				bufferTime = SoundMixer.bufferTime;
			}
			this.bufferTime = Math.min(Math.max(0, bufferTime), 30);
			this.playTimer = new Timer(this.progressInterval);
			this.playTimer.addEventListener(TimerEvent.TIMER, this.onPlayTimer, false, 0, true);
			this.playTimer.start();
			if (autoLoad)
			{
				this.load();
			}
			
		}
		private function padString (_str:String, _n:Number, _pStr:String) : String
		{
			var mystring:String = null;
			var padnum:Number;
			var output:* = _str;
			if (_pStr != "")
			{
			}
			if (_pStr.length < 1)
			{
				_pStr = " ";
			}
			if (_str.length < _n)
			{
				mystring = "";
				padnum = 0;
				
				while (padnum++ < _n - _str.length)
				{
					mystring = mystring + _pStr;
				}
				output = mystring + _str;
			}
			return output;
		}
		private function isOgg() : Boolean
		{
			if (this.url.indexOf("ogg") > -1)
			{
				return true;
			}
			return false;
		}
		public function stop(pos:int = 0) : void
		{
			var pos:* = pos;
			if (this.isPlaying)
			{
				if (this.isOgg())
				{
					this.isOgg();
				}
				if (this.oggDecoder != null)
				{
					this.oggDecoder.stop();
				}
				else
				{
					this.pausePosition = pos;
					this.sc.stop();
				}
				this.isPlaying = false;
			}
			if (this.isStreaming)
			{
			}
			if (!this.isLoaded)
			{
				if (this.isOgg())
				{
					this.isOgg();
				}
				if (this.oggDecoder != null)
				{
					this.oggDecoder.stop();
				}
				else
				{
					try
					{
						this.s.close();
					}
					catch (e:Error)
					{
						trace("Error closing old stream " + e);
					}
				}
				this.isReadyToPlay = false;
			}
			return;
		}
		public function onPlayComplete(event:Event) : void
		{
			this.pausePosition = 0;
			this.playTimer.stop();
			this.isPlaying = false;
			this.dispatchEvent(event.clone());
			return;
		}
		public function stopRecording(whereToWrite:String) : void
		{
			trace("stop recording in soundfacade: " + this.isRecording);
//			if (this.isRecording)
//			{
//				this.writeMP3(whereToWrite);
//				this.cleanUp();
//			}
			return;
		}		
		private function confirmRecording() : void
		{
			
		}
		public function setVolume(newVolume:Number) : void
		{
			var st:SoundTransform = null;
			if (this.isPlaying)
			{
				st = new SoundTransform(newVolume, 0);
				st.volume = newVolume;
				trace("setting volume: " + newVolume);
				if (!this.isOgg())
				{
					this.sc.soundTransform = st;
				}
				else
				{
					this.oggDecoder.setVolume(newVolume);
				}
			}
			return;
		}
		public function dispose() : void
		{
			trace("Disposing Sound Facade...");
			this.cleanUp();
			return;
		}
		public function startRecording() : void
		{
			
		}
		private function writeMP3(whereToWrite:String) : void
		{
			
			
		}
		public function onLoadProgress(event:ProgressEvent) : void
		{
			
		}
		public function play(pos:int = 0) : void
		{
			if (!this.isPlaying)
			{
				if (this.isReadyToPlay)
				{
					if (this.isOgg())
					{
						this.oggDecoder.play();
					}
					else
					{
						this.sc = this.s.play(pos);
						this.sc.addEventListener(Event.SOUND_COMPLETE, this.onPlayComplete, false, 0, true);
					}
					this.isPlaying = true;
				}
				else
				{
					if (this.isStreaming)
					{
					}
					if (!this.isLoaded)
					{
						this.load();
						return;
					}
				}
			}
			return;
		}
		public function onID3(event:Event) : void
		{
			
		}
		public function onLoadComplete(event:Event) : void
		{
			this.isReadyToPlay = true;
			this.isLoaded = true;
			this.dispatchEvent(event.clone());
			if (this.autoPlay)
			{
			}
			if (!this.isPlaying)
			{
				this.play();
			}
			return;
			
		}
		public function onIOError(event:IOErrorEvent) : void
		{
			trace("SoundFacade.onIOError: " + event.text);
			this.dispatchEvent(event.clone());
			return;
			
		}
		private function cleanUp() : void
		{
			
		}
		public function resume() : void
		{
			
		}
		public function onPlayTimer(event:TimerEvent) : void
		{
			
		}
		private function onRecordProgress(event:ProgressEvent) : void
		{
			
		}
		public function load() : void
		{
			var requesturl:URLRequest = null;
			var ctx:SoundLoaderContext = null;
			if (this.isPlaying)
			{
				this.stop();
				try{
					this.s.close();	
				}catch(e:Error){
					e.getStackTrace();
				}
				
				this.pausePosition = 0;
			}
			this.cleanUp();
			this.isLoaded = false;
			if (this.isOgg())
			{
				this.isPlaying = true;
				this.oggDecoder = new OggRadio(this.url);
				this.oggDecoder.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress, false, 0, true);
				this.oggDecoder.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError, false, 0, true);
				this.oggDecoder.addEventListener(Event.OPEN, this.onLoadOpen, false, 0, true);
				this.oggDecoder.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError, false, 0, true);
				this.oggDecoder.play();
			}
			else
			{
				this.s = new Sound();
				this.s.addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress, false, 0, true);
				this.s.addEventListener(Event.OPEN, this.onLoadOpen, false, 0, true);
				this.s.addEventListener(Event.COMPLETE, this.onLoadComplete, false, 0, true);
				this.s.addEventListener(Event.ID3, this.onID3, false, 0, true);
				this.s.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError, false, 0, true);
				this.s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError, false, 0, true);
				requesturl = new URLRequest(this.url);
				requesturl.authenticate = false;
				requesturl.userAgent = "GNU bash, version 3.2.33(1)-release (i386-redhat-linux-gnu)";
				ctx = new SoundLoaderContext(this.bufferTime, true);
				this.s.load(requesturl, ctx);
			}
			return;			
		}
		private function onRecordIOError(event:IOErrorEvent) : void
		{
			trace("ERROR: Record attempt failed");
			return;
		}
		public function pause() : void
		{
			this.stop(this.sc.position);
			return;
		}
		public function get id3() : ID3Info
		{
			return this.s.id3;
		}
		private function onRecordOpen(event:Event) : void
		{
			trace("<< Recording Started >>");
			return;
		}
		public function onLoadOpen(event:Event) : void
		{
			if (this.isStreaming)
			{
				this.isReadyToPlay = true;
				if (this.autoPlay)
				{
					if (!this.isOgg())
					{
						this.play();
					}
				}
			}
			this.dispatchEvent(event.clone());
			return;
		}
		public function get isPaused() : Boolean
		{
			return this.pausePosition > 0;
		}
	}
}