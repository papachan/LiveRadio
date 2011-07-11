package net.androidda.examples.liveradio.dao
{
	import mx.collections.ArrayCollection;

	public class AppModel
	{
		[Bindable]
		public var radio:ArrayCollection = new ArrayCollection();
		
		public var isInitialized:Boolean = false;
		
		public function AppModel(enforcer:SingletonEnforcer )
		{
			init();
		}
		private static var _instance:AppModel;
		
		public static function getInstance():AppModel
		{
			if ( _instance == null )
			{
				_instance = new AppModel( new SingletonEnforcer());
			}
			return _instance;
			
		}
		protected function init() : void{
			
		}
	}
}
internal  class SingletonEnforcer {}