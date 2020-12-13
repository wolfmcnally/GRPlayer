package bigpix.examples;

import bigpix.*;

public class Player extends BigPix.Program {
	final Point MAX_POINT;

	int playerX;
	int playerY;

	int playerLastX;
	int playerLastY;


	public static void main(String... args) {
		BigPix.start(new Player());
	}

	public Player() {
		MAX_POINT = getMaxPoint();
	}

	public void run() {
		setupModel();

		while(true) {
			drawFrame();
			endFrame();

			updateModel();
		}
	}

	public void endFrame() {
		flush();
		sleep(1.0 / 15);
	}

	private void setupModel() {
		playerX = MAX_POINT.x / 2;
		playerY = MAX_POINT.y / 2;

		playerLastX = 0;
		playerLastY = 0;
	}

	private void updateModel() {
		String keysDown = getKeysDown();
		System.out.println("keysDown" + keysDown);

		if(keysDown.contains("A")) {
			playerX--;
			if(playerX < 0) playerX = 0;
		}

		if(keysDown.contains("D")) {
			playerX++;
			if(playerX > MAX_POINT.x) playerX = MAX_POINT.x;
		}

		if(keysDown.contains("W")) {
			playerY--;
			if(playerY < 0) playerY = 0;
		}

		if(keysDown.contains("S")) {
			playerY++;
			if(playerY > MAX_POINT.y) playerY = MAX_POINT.y;
		}
	}

	private void drawFrame() {
		if(playerX != playerLastX || playerY != playerLastY) {
			setPixel(playerLastX, playerLastY, Color.BLACK);
			setPixel(playerX, playerY, Color.WHITE);
			playerLastX = playerX;
			playerLastY = playerY;
		}
	}
}
