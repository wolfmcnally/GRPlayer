package javapractice.work;

import bigpix.*;
import java.util.ArrayList;
import java.util.LinkedList;

public class Snake extends BigPix.Program {
	private static final Offset OFFSET_UP = new Offset(0, -1);
	private static final Offset OFFSET_DOWN = new Offset(0, 1);
	private static final Offset OFFSET_LEFT = new Offset(-1, 0);
	private static final Offset OFFSET_RIGHT = new Offset(1, 0);

	private static final int APPLES_COUNT = 10;

	private static final int PLAYER_START_LENGTH = 5;
	private static final int PLAYER_GROWTH_LENGTH = 5;

	private final int SQUARE_SPACE = 0;
	private final int SQUARE_APPLE = 1;
	private final int SQUARE_SNAKE_BODY = 2;
	private final int SQUARE_WALL = 3;

	private Point playerPosition;
	private Offset playerDirection;
	private ArrayList<Point> apples;
	private LinkedList<Point> playerBodyPositions;
	private int playerLength;
	private int[][] boardSquares;
	private int score;
	private Color backgroundColor;
	private Color playerBodyColor;
	private Color playerHeadColor;
	private boolean crashed;

	public static void main(String... args) {
		BigPix.start(new Snake());
	}

	public void run() {

		setupGame();

		//noinspection InfiniteLoopStatement
		while(true) {
			updateModel();

			if(crashed) {
				crashEffect();
				setupGame();
			}

			drawFrame();
			sleep(0.1);
		}
	}

	private void crashEffect() {
		float ti = 1.0f / 30;

		for(float t = 0.0f; t <= 1.0f; t += ti) {
			float brightness = 1.0f - t;
			backgroundColor = new Color(brightness, brightness, brightness);
			playerBodyColor = new Color(brightness, 0, 0);
			playerHeadColor = new Color(brightness, brightness, 0);
			drawFrame();
			sleep(ti);
		}

		sleep(1.0);
	}

	private void setupGame() {
		crashed = false;

		setupGraphics();
		setupBoard();
		setupWalls();
		setupPlayer();
		setupApples();
	}

	private void setupGraphics() {
		backgroundColor = Color.BLACK;
		playerBodyColor = Color.GREEN;
		playerHeadColor = Color.WHITE;
	}

	private void setupBoard()
	{
		Size boardSize = getDimensions();
		boardSquares = new int[boardSize.width][boardSize.height];
	}

	private void setSquare(int val, int x, int y)
	{
		boardSquares[x][y] = val;
	}

	private int getSquare(Point p)
	{
		return boardSquares[p.x][p.y];
	}

	private void setSquare(int val, Point p)
	{
		setSquare(val, p.x, p.y);
	}

	private void updateModel()
	{
		steerPlayer();
		movePlayer();
	}

	private void movePlayer() {
		Point newPlayerPosition = playerPosition.add(playerDirection);

		int square = getSquare(newPlayerPosition);

		boolean keepGoing = false;

		if(square == SQUARE_SPACE || square == SQUARE_APPLE) {
			keepGoing = true;
		}

		if(square == SQUARE_APPLE) {
			eatApple(newPlayerPosition);
		}

		if(keepGoing) {
			playerPosition = newPlayerPosition;

			playerBodyPositions.add(playerPosition);
			setSquare(SQUARE_SNAKE_BODY, playerPosition);

			while(playerBodyPositions.size() > playerLength) {
				Point p = playerBodyPositions.remove();
				setSquare(SQUARE_SPACE, p);
			}
		} else {
			crashed = true;
		}
	}

	private void steerPlayer() {
		String keysDown = getKeysDown();
//		print("keysDown" + keysDown);

		if(keysDown.contains("A")) {
			facePlayerLeft();
		} else if(keysDown.contains("D")) {
			facePlayerRight();
		} else if(keysDown.contains("W")) {
			facePlayerUp();
		} else if(keysDown.contains("S")) {
			facePlayerDown();
		}
	}

	public void drawFrame()
	{
		erase(backgroundColor);
		drawWalls();
		drawApples();
		drawPlayer();
		flush(true);
	}
	
	private void drawWalls() {
		Color borderColor = Color.BLUE;
		setPenColor(borderColor);
		Point maxPoint = getMaxPoint();
		drawHLine(0, maxPoint.x, 0);				// Top wall
		drawHLine(0, maxPoint.x, maxPoint.y);		// Bottom wall
		drawVLine(0, maxPoint.y, 0);				// Left wall
		drawVLine(0, maxPoint.y, maxPoint.x);		// Right wall
	}

	private void setupWalls()
	{
		Point maxPoint = getMaxPoint();
		setSquaresHLine(SQUARE_WALL, 0, maxPoint.x, 0);				// Top wall
		setSquaresHLine(SQUARE_WALL, 0, maxPoint.x, maxPoint.y);		// Bottom wall
		setSquaresVLine(SQUARE_WALL, 0, maxPoint.y, 0);				// Left wall
		setSquaresVLine(SQUARE_WALL, 0, maxPoint.y, maxPoint.x);		// Right wall
	}

	private void setSquaresHLine(int val, int x1, int x2, int y) {
		for(int x = x1; x <= x2; x++) {
			setSquare(val, x, y);
		}
	}

	private void setSquaresVLine(int val, int y1, int y2, int x) {
		for(int y = y1; y <= y2; y++) {
			setSquare(val, x, y);
		}
	}

	private void drawApple(Point p)
	{
		setPixel(p, Color.RED);
	}

	private void drawApples()
	{
		for(Point p : apples) {
			drawApple(p);
		}
	}

	private Point findApplePoint() {
		Point applePoint;

		Point maxPoint = getMaxPoint();
		boolean done = false;
		do {
			int x, y;
			x = Random.randomInt(0, maxPoint.x);
			y = Random.randomInt(0, maxPoint.y);
			applePoint = new Point(x, y);
			if(getSquare(applePoint) == SQUARE_SPACE) {
				done = true;
			}
		} while(!done);

		return applePoint;
	}

	private void setupApples() {
		apples = new ArrayList<Point>();

		for(int i = 0; i < APPLES_COUNT; i++) {
			Point applePoint = findApplePoint();
			apples.add(applePoint);
			setSquare(SQUARE_APPLE, applePoint);
		}
	}

	private void eatApple(Point p) {
		setSquare(SQUARE_SPACE, p);

		int index = apples.indexOf(p);
		if(index != -1) {
			apples.remove(index);
		}

		playerLength += PLAYER_GROWTH_LENGTH;
		
		score++;
		print("Score:" + score);
	}

	private void setupPlayer() {
		Point maxPoint = getMaxPoint();
		int x = maxPoint.x / 2;
		int y = maxPoint.y - 1;
		playerPosition = new Point(x, y);

		playerBodyPositions = new LinkedList<Point>();
		playerLength = PLAYER_START_LENGTH;

		facePlayerUp();
	}

	private void drawPlayer() {
		for(Point p : playerBodyPositions) {
			setPixel(p, playerBodyColor);
		}

		setPixel(playerPosition, playerHeadColor);
	}

	private void facePlayerUp() {
		playerDirection = OFFSET_UP;
	}

	private void facePlayerDown() {
		playerDirection = OFFSET_DOWN;
	}

	private void facePlayerLeft() {
		playerDirection = OFFSET_LEFT;
	}

	private void facePlayerRight() {
		playerDirection = OFFSET_RIGHT;
	}
}
