package bigpix.examples;

import bigpix.*;

public class Shapes extends BigPix.Program {

	public static void main(String... args) {
		BigPix.start(new Shapes());
	}
	
	Size screenSize = getDimensions();
	final boolean T = true;
	final boolean F  = false;
	Point maxPoint = getMaxPoint();
	
	boolean[][] myHeart = new boolean[][] {
		{ F,F,T,T,T,F,F,F,T,T,T,F,F },
		{ F,T,T,T,T,T,F,T,T,T,T,T,F },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ F,T,T,T,T,T,T,T,T,T,T,T,F },
		{ F,F,T,T,T,T,T,T,T,T,T,F,F },
		{ F,F,F,T,T,T,T,T,T,T,F,F,F },
		{ F,F,F,F,T,T,T,T,T,F,F,F,F },
		{ F,F,F,F,F,T,T,T,F,F,F,F,F },
		{ F,F,F,F,F,F,T,F,F,F,F,F,F }
	};
	
	boolean[][] mySpade = new boolean[][] {
		{ F,F,F,F,F,F,T,F,F,F,F,F,F },
		{ F,F,F,F,F,T,T,T,F,F,F,F,F },
		{ F,F,F,F,T,T,T,T,T,F,F,F,F },
		{ F,F,T,T,T,T,T,T,T,T,T,F,F },
		{ F,T,T,T,T,T,T,T,T,T,T,T,F },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ F,T,T,T,T,F,T,F,T,T,T,T,F },
		{ F,F,F,F,F,F,T,F,F,F,F,F,F },
		{ F,F,F,F,F,T,T,T,F,F,F,F,F },
		{ F,F,F,F,T,T,T,T,T,F,F,F,F },
	};
	
	boolean[][] myDiamond = new boolean[][] {
		{ F,F,F,F,F,F,T,F,F,F,F,F,F },
		{ F,F,F,F,F,T,T,T,F,F,F,F,F },
		{ F,F,F,F,T,T,T,T,T,F,F,F,F },
		{ F,F,F,T,T,T,T,T,T,T,F,F,F },
		{ F,F,T,T,T,T,T,T,T,T,T,F,F },
		{ F,T,T,T,T,T,T,T,T,T,T,T,F },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ F,T,T,T,T,T,T,T,T,T,T,T,F },
		{ F,F,T,T,T,T,T,T,T,T,T,F,F },
		{ F,F,F,T,T,T,T,T,T,T,F,F,F },
		{ F,F,F,F,T,T,T,T,T,F,F,F,F },
		{ F,F,F,F,F,T,T,T,F,F,F,F,F },
		{ F,F,F,F,F,F,T,F,F,F,F,F,F },
	};
	
	boolean[][] myClub = new boolean[][] {
		{ F,F,F,F,F,F,T,T,F,F,F,F,F,F },
		{ F,F,F,F,F,T,T,T,T,F,F,F,F,F },
		{ F,F,F,F,T,T,T,T,T,T,F,F,F,F },
		{ F,F,F,F,T,T,T,T,T,T,F,F,F,F },
		{ F,F,T,T,F,T,T,T,T,F,T,T,F,F },
		{ F,T,T,T,T,F,T,T,F,T,T,T,T,F },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ T,T,T,T,T,T,T,T,T,T,T,T,T,T },
		{ F,T,T,T,T,F,T,T,F,T,T,T,T,F },
		{ F,F,T,T,F,F,T,T,F,F,T,T,F,F },
		{ F,F,F,F,F,T,T,T,T,F,F,F,F,F },
		{ F,F,F,F,T,T,T,T,T,T,F,F,F,F }
	};

	public void run() {
		//noinspection InfiniteLoopStatement
		while(true) {
			setPenColor(Color.RED);
			rowLoops(myHeart);
			delay();
			
			setPenColor(Color.BLUE);
			rowLoops(mySpade);
			delay();
			
			setPenColor(Color.WHITE);
			rowLoops(myDiamond);
			delay();
			
			setPenColor(Color.GREEN);
			rowLoops(myClub);
			delay();
		}
	}
	
	public int center(int objectSize, int screenSize) {
		return screenSize / 2 - objectSize / 2;
	}
	
	public void drawShape(boolean[][] shape, int xLoc, int yLoc) {
		for(int y = 0; y < shape.length; y++) {
			for(int x = 0; x < shape[y].length; x++) {
				if(shape[y][x]) {
					setPixel(x + xLoc, y + yLoc);
				}
			}
		}
	}

	// NOTE: A method name should be descriptive of what it does. In this case, it is under-descriptive,
	// because it clearly does more than delay. I would call a method like this "endFrame()" because it
	// does whatever is necessary at the end of a frame.
	public void delay(){
		flush();
		sleep(0.1);
		erase(Color.BLACK);
	}

	// NOTE: On the other hand, this method name is over-descriptive because it tells you _how_ it does
	// something (loops) instead of _what_ it does. I would name a method like this something like "animate()"
	// because given a shape it generates a sequence of animation.
	public void rowLoops(boolean[][] shape){

		// FIX: You don't need this booleans. See below.
		boolean topRow = true;
		boolean centerRow = true;
		boolean bottomRow = true;
		
		int shapeHeight = shape.length;
		int y = center(shape.length, maxPoint.y);

		// FIX: You already have your for-loops, so why do you need to surround them with while-loops?
		while(topRow) {
			for(int i = 0; i < 12; i++) {
				drawShape(shape, i * 3, 0);
				delay();

				// FIX: Likewise, your for-loops already have perfectly good termination conditions (i < 12), so why
				// put special termination condition in here?
				if(i == 11) {
					topRow = false;
				}
			}
		}
		while(centerRow) {
			for(int i = 0; i < 12; i++) {
				drawShape(shape, i * 3, y);
				delay();
				if(i == 11) {
					centerRow = false;
				}
			}
		}
		while(bottomRow) {
			for(int i = 0; i < 12; i++) {
				drawShape(shape, i *3, screenSize.height - shapeHeight);
				delay();
				if(i == 11) {
					bottomRow = false;
					erase(Color.BLACK);
					flush();
				}
			}
		}
	}
	
	public Size getDimensions() {
		return new Size(48, 40);
	}
}
