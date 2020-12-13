package bigpix.examples;

import bigpix.*;

public class Xxx extends BigPix.Program {

	public static void main(String... args) {
		BigPix.start(new Xxx());
	}

	public void run() {
		Point maxPoint = getMaxPoint();
		drawX(0, 0, 39);
		drawX(maxPoint.x / 2 - 3, 5, 7);
		drawX(maxPoint.x / 2 - 3, 27, 7);
		drawX(maxPoint.x / 8, maxPoint.y / 2 -3, 7);
		drawX((maxPoint.x / 8) * 7, maxPoint.y / 2 - 3, 7);
	}

	public void drawX(int x, int y, int size){
		for (int i = 0; i < size; i++){
			setPenColor(Random.randomColor());
			setPixel(x + i, y + i);
			setPixel(x + size - i - 1, y + i);
			flush();
			sleep(0.05);
		}
	}
}