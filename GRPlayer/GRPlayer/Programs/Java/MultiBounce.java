package bigpix.examples;

import bigpix.*;

public class MultiBounce extends BigPix.Program {
	final Point MAX_POINT;
	final int NUM_BALLS = 20;

	Point[] ballPositions;
	Offset[] ballDirections;
	Color[] ballColors;
	
	public static void main(String... args) {
		BigPix.start(new MultiBounce());
	}

	protected MultiBounce() {
		MAX_POINT = getMaxPoint();
	}

	@Override
	public void run() {
		setupModel();

		//noinspection InfiniteLoopStatement
		while(true) {
			beginFrame();
			drawFrame();
			endFrame();

			updateModel();
		}
	}

	//
	// Drawing methods: These methods do not change the model
	//

	private void beginFrame() {
		erase(Color.BLACK);
	}

	private void endFrame() {
		flush();
		sleep(0.05);
	}

	private void drawFrame() {
		for(int i = 0; i < NUM_BALLS; i++){
			setPixel(ballPositions[i], ballColors[i]);
		}
	}

	//
	// Model methods: These methods do not draw
	//

	private void setupModel() {
		ballPositions = new Point[NUM_BALLS];
		ballDirections = new Offset[NUM_BALLS];
		ballColors = new Color[NUM_BALLS];
		
		for(int i = 0; i < NUM_BALLS; i++) {
			ballPositions[i] = Random.randomPoint(MAX_POINT);
			ballDirections[i] = new Offset(Random.coinFlip() ? -1 : 1, Random.coinFlip() ? -1 : 1);
			ballColors[i] = Random.randomColor();
		}
	}
	
	private void updateModel() {
		for(int i =0; i < NUM_BALLS; i++) {
			Point originalPosition = ballPositions[i];
			Offset direction = ballDirections[i];
			Point newPosition = originalPosition.add(direction);

			if(newPosition.x < 0 || newPosition.x > MAX_POINT.x) {
				direction = direction.negateDX();
				newPosition = originalPosition.add(direction);
			}

			if(newPosition.y < 0 || newPosition.y > MAX_POINT.y) {
				direction = direction.negateDY();
				newPosition = originalPosition.add(direction);
			}

			ballDirections[i] = direction;
			ballPositions[i] = newPosition;
		}
	}
}
