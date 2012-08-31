// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events
{
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    import starling.core.starling_internal;
    import starling.display.DisplayObject;
    import starling.utils.MatrixUtil;
    import starling.utils.formatString;

    /** 一个Touch对象包含了在屏幕上的一个手指或鼠标的相关信息（出现或移动）。
     *  
     *  <p>您将从TouchEvent中获取这个对象。当这样的事件被触发，您可以查询目前呈现在屏幕上的所有触碰。
     *  一个Touch对象，包含了一个单指触碰的信息。一个Touch对象总是会通过TouchPhases的集合移动。请参阅TouchPhase类来获取更多信息。</p>
     *  
     *  <strong>触碰的位置</strong>
     *  
     *  <p>您可以用相应的属性，获取坐标系上的当前的和上一个位置。当然，在大部分情况下您希望能获取在一个不同的坐标系上的位置。 基于这个原因，这里有一些方法可以转换当前的和上一个位置到任何对象的局部坐标系。</p>
     * 
     *  @see TouchEvent
     *  @see TouchPhase
     */  
    public class Touch
    {
        private var mID:int;
        private var mGlobalX:Number;
        private var mGlobalY:Number;
        private var mPreviousGlobalX:Number;
        private var mPreviousGlobalY:Number;
        private var mTapCount:int;
        private var mPhase:String;
        private var mTarget:DisplayObject;
        private var mTimestamp:Number;
        
        /** Helper object. */
        private static var sHelperMatrix:Matrix = new Matrix();
        
        /** Creates a new Touch object. */
        public function Touch(id:int, globalX:Number, globalY:Number, phase:String, target:DisplayObject)
        {
            mID = id;
            mGlobalX = mPreviousGlobalX = globalX;
            mGlobalY = mPreviousGlobalY = globalY;
            mTapCount = 0;
            mPhase = phase;
            mTarget = target;
        }
        
        /** Converts the current location of a touch to the local coordinate system of a display 
         *  object. If you pass a 'resultPoint', the result will be stored in this point instead 
         *  of creating a new object.*/
        public function getLocation(space:DisplayObject, resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();
            mTarget.base.getTransformationMatrix(space, sHelperMatrix);
            return MatrixUtil.transformCoords(sHelperMatrix, mGlobalX, mGlobalY, resultPoint); 
        }
        
        /** Converts the previous location of a touch to the local coordinate system of a display 
         *  object. If you pass a 'resultPoint', the result will be stored in this point instead 
         *  of creating a new object.*/
        public function getPreviousLocation(space:DisplayObject, resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();
            mTarget.base.getTransformationMatrix(space, sHelperMatrix);
            return MatrixUtil.transformCoords(sHelperMatrix, mPreviousGlobalX, mPreviousGlobalY, resultPoint);
        }
        
        /** Returns the movement of the touch between the current and previous location. 
         *  If you pass a 'resultPoint', the result will be stored in this point instead 
         *  of creating a new object. */ 
        public function getMovement(space:DisplayObject, resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();
            getLocation(space, resultPoint);
            var x:Number = resultPoint.x;
            var y:Number = resultPoint.y;
            getPreviousLocation(space, resultPoint);
            resultPoint.setTo(x - resultPoint.x, y - resultPoint.y);
            return resultPoint;
        }
        
        /** Returns a description of the object. */
        public function toString():String
        {
            return formatString("Touch {0}: globalX={1}, globalY={2}, phase={3}",
                                mID, mGlobalX, mGlobalY, mPhase);
        }
        
        /** Creates a clone of the Touch object. */
        public function clone():Touch
        {
            var clone:Touch = new Touch(mID, mGlobalX, mGlobalY, mPhase, mTarget);
            clone.mPreviousGlobalX = mPreviousGlobalX;
            clone.mPreviousGlobalY = mPreviousGlobalY;
            clone.mTapCount = mTapCount;
            clone.mTimestamp = mTimestamp;
            return clone;
        }
        
        /** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
        public function get id():int { return mID; }
        
        /** The x-position of the touch in stage coordinates. */
        public function get globalX():Number { return mGlobalX; }

        /** The y-position of the touch in stage coordinates. */
        public function get globalY():Number { return mGlobalY; }
        
        /** The previous x-position of the touch in stage coordinates. */
        public function get previousGlobalX():Number { return mPreviousGlobalX; }
        
        /** The previous y-position of the touch in stage coordinates. */
        public function get previousGlobalY():Number { return mPreviousGlobalY; }
        
        /** The number of taps the finger made in a short amount of time. Use this to detect 
         *  double-taps / double-clicks, etc. */ 
        public function get tapCount():int { return mTapCount; }
        
        /** The current phase the touch is in. @see TouchPhase */
        public function get phase():String { return mPhase; }
        
        /** The display object at which the touch occurred. */
        public function get target():DisplayObject { return mTarget; }
        
        /** The moment the touch occurred (in seconds since application start). */
        public function get timestamp():Number { return mTimestamp; }
        
        // internal methods
        
        /** @private */
        starling_internal function setPosition(globalX:Number, globalY:Number):void
        {
            mPreviousGlobalX = mGlobalX;
            mPreviousGlobalY = mGlobalY;
            mGlobalX = globalX;
            mGlobalY = globalY;
        }
        
        /** @private */
        starling_internal function setPhase(value:String):void { mPhase = value; }
        
        /** @private */
        starling_internal function setTapCount(value:int):void { mTapCount = value; }
        
        /** @private */
        starling_internal function setTarget(value:DisplayObject):void { mTarget = value; }
        
        /** @private */
        starling_internal function setTimestamp(value:Number):void { mTimestamp = value; }
    }
}