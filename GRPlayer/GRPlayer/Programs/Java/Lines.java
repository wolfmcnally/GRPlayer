package bigpix.examples;

import bigpix.*;

public class Lines extends BigPix.Program {

	public static void main(String... args) {
		BigPix.start(new Lines());
	}

	public void run() {
		final Point MAX_POINT = getMaxPoint();

		while(true) {
			setPenColor(Random.randomColor());
			if(Random.randomInt(0, 1) == 0) {
				int x1 = Random.randomInt(0, MAX_POINT.x);
				int x2 = Random.randomInt(0, MAX_POINT.x);
				if(x2 < x1) {
					int t = x1; x1 = x2; x2 = t;
				}
				int y = Random.randomInt(0, MAX_POINT.y);
				drawHLine(x1, x2, y);
			} else {
				int y1 = Random.randomInt(0, MAX_POINT.y);
				int y2 = Random.randomInt(0, MAX_POINT.y);
				if(y2 < y1) {
					int t = y1; y1 = y2; y2 = t;
				}
				int x = Random.randomInt(0, MAX_POINT.x);
				drawVLine(y1, y2, x);
			}
			flush();
			sleep(0.01);
		}
	}
}
