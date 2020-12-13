package bigpix.examples;

import bigpix.*;

public class Sierpinski extends BigPix.Program {

	final Point MAX_POINT = getMaxPoint();
	final int NUM_PIX = 10000;
	public float x1, y1, x2, y2, x3, y3, startX, startY,
	dirX, dirY, targetX, targetY, nextDirX, nextDirY, 
	nextX, nextY;
	
	public static void main(String... args) {
		BigPix.start(new Sierpinski());
	}

	public void run() {
		//noinspection InfiniteLoopStatement
		while(true) {
			getPoints();
			flush(true);
			//erase(Color.BLACK);
		}
	}
	
	public void getPoints() {
		x1 = MAX_POINT.x / 2;
		y1 = 0;
		x2 = x1 / 2;
		y2 = MAX_POINT.y / 2;
		x3 = MAX_POINT.x / 4 * 3;
		y3 = y2;	

		int select = randomInt(1, 3);
		if(select == 1) {
			startX = x1;
			startY = y1;
			dirX = x2;
			dirY = y2;
		} else if (select == 2) {
			startX = x2;
			startY = y2;
			dirX = x3;
			dirY = y3;
		} else {
			startX = x3;
			startY = y3;
			dirX = x1;
			dirY = y1;
		}
		targetX = (startX + dirX) / 2;
		targetY = (startY + dirY) / 2;
		startX = targetX;
		startY = targetY;
		setPixel((int)(targetX + 0.5), (int)(targetY + 0.5), Random.randomColor());

		for(int i = 0; i < NUM_PIX; i++) {
			int nextSelect = randomInt(1, 3);
			if(nextSelect == 1) {
				nextDirX = x2;
				nextDirY = y2;
			} else if (nextSelect == 2) {
				nextDirX = x3;
				nextDirY = y3;
			} else {
				nextDirX = x1;
				nextDirY = y1;
			}
			targetX = (startX + nextDirX) / 2;
			targetY = (startY + nextDirY) / 2;
			startX = targetX;
			startY = targetY;
			setPixel((int)(targetX + 0.5), (int)(targetY + 0.5), Random.randomColor());
		}
	}
	
	public static int randomInt(int minVal, int maxVal) { 
		return (int)(Math.random() * (maxVal - minVal + 1) + minVal);
	}
	
	public Size getPixelSize() {
		return new Size (1, 1);
	}
	
	public Size getDimensions() {
		return new Size (700, 700);
	}
}