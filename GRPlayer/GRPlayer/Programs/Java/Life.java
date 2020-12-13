package bigpix.examples;

import bigpix.*;

public class Life extends BigPix.Program {
	
	Point MAX_POINT = getMaxPoint();
	final float PERCENT_DRAWN = 0.4f;
	Size screenSize = getDimensions();
	
	public static void main(String... args) {
		BigPix.start(new Life());
	}
	
	public void run() {
		erase(Color.BLACK, Color.GRAY);
		seed();
		while(true) {
			flush(true);
			//sleep(0.1);
			scan();
			clean();
		}
	}
	
	public void scan() {
		for(int y = 0; y <= MAX_POINT.y; y++) {
			for(int x = 0; x <= MAX_POINT.x; x++) {
				int neighbors = countNeighbors(x, y);
				if(!isAlive(x, y)){
					if(neighbors == 3) {
						setPixel(x, y, Color.GREEN);
					}
				} else {
					if(neighbors != 2 && neighbors != 3) {
						setPixel(x, y, Color.RED);
					}
				}
			}
		}
	}
	
	public void seed() {
		for(int y = 0; y <= MAX_POINT.y; y++) {
			for(int x = 0; x <= MAX_POINT.x; x++) {
				if(Random.randomFloat(0.0f, 1.0f) <= PERCENT_DRAWN) {
					setPixel(x, y, Color.WHITE);
				}
			}
		}
	}
	
	public boolean isAlive(int x,int y) {
		if(x < 0) {
			x += screenSize.width;
		}
		if(y < 0) {
			y += screenSize.height;
		}
		int px = x % screenSize.width;
		int py = y % screenSize.height;
		Color c = getPixel(px, py);
		return c.equals(Color.WHITE) || c.equals(Color.RED);
	}
	
	public int countNeighbors(int x, int y) {
		int count = 0;
		if(isAlive(x - 1, y - 1)) count++;
		if(isAlive(x    , y - 1)) count++;
		if(isAlive(x + 1, y - 1)) count++;
		if(isAlive(x - 1, y    )) count++;
		if(isAlive(x + 1, y	   )) count++;
		if(isAlive(x - 1, y + 1)) count++;
		if(isAlive(x    , y + 1)) count++;
		if(isAlive(x + 1, y + 1)) count++;
		return count;
	}
	
	public void clean() {
		for(int y = 0; y <= MAX_POINT.y; y++) {
			for(int x = 0; x <= MAX_POINT.x; x++) {
				Color c = getPixel(x, y);
				if(c.equals(Color.GREEN)) {
					setPixel(x, y, Color.WHITE);
				} else if(c.equals(Color.RED)) {
					setPixel(x, y, Color.BLACK);
				}
			}
		}
	}
	
	public Size getDimensions() {
		return new Size(100, 100);
	}
	
	public Size getPixelSize() {
		return new Size(5, 5);
	}
}