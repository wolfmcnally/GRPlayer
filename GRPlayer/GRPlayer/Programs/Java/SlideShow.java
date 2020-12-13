package bigpix.examples;

import bigpix.*;

public class SlideShow extends BigPix.Program {
	
	final Point MAX_POINT = getMaxPoint();
	
	public static void main(String... args) {
		BigPix.start(new SlideShow());
	}
	
	public void run() {
		//noinspection InfiniteLoopStatement
		while(true) {
			beginSlide();
			drawSlideHLine();
			endSlide();

			beginSlide();
			drawSlideVLine();
			endSlide();
			
			beginSlide();
			drawSlideRandomPixel();
			endSlide();
			
			beginSlide();
			drawSlideCheckerboard();
			endSlide();
			
			beginSlide();
			drawSlideFrame();
			endSlide();
		}
	}

	public void beginSlide() {
		erase(Color.BLACK);
		setPenColor(Random.randomColor());
	}

	public void endSlide() {
		flush();
		sleep (5.00);
	}
	
	public void drawSlideHLine() {
		for(int y = 0; y <= MAX_POINT.y; y += 2) {
			drawHLine(0, MAX_POINT.x, y);
		}
	}
	
	public void drawSlideVLine() {
		for(int x = 0; x <= MAX_POINT.x; x += 2) {
			drawVLine(0, MAX_POINT.y, x);
		}
	}
	
	public void drawSlideRandomPixel(){
		for (int y = 0; y <= MAX_POINT.y; y++ ){
			for (int x = 0; x <= MAX_POINT.x; x++){
				if(Random.randomInt(0, 1)== 0){
					setPixel(x,y);
				}
			}
		}
	}
	
	public void drawSlideCheckerboard(){
		for (int x = 0; x <= MAX_POINT.x; x++){
			for (int y = 0; y <= MAX_POINT.y; y++){
				if (((x + y) & 1) == 0){
					setPixel(x, y);
				}
			}
		}
	}
	
	public void drawSlideFrame(){
		drawVLine(0, MAX_POINT.y, 0);
		drawVLine(0, MAX_POINT.y, MAX_POINT.x);
		drawHLine(0, MAX_POINT.x, 0);
		drawHLine(0, MAX_POINT.x, MAX_POINT.y);
		
	}
	
	public Size getDimensions() {
		return new Size(41, 41);
	}
}