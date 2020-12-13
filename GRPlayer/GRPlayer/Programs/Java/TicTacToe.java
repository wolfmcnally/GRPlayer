package bigpix.examples;

import bigpix.*;
import java.util.*;

public class TicTacToe {

	// This enumerated type represents the three possible values for a board square. Each value of Move is an object that
	// stores the character to be printed for a particular move value.
	private enum Move {
		NO_MOVE(' '),     // No move made here yet
		X_MOVE('X'),      // X has moved here
		O_MOVE('O');      // O has moved here

		Move(char c) {
			this.c = c;
		}

		public char moveChar() { return c; }

		private char c;
	}

	// This dimension object encapsulates the board dx and dy
	// WARNING: The program currently makes certain assumptions that could lead to crashing if the board dx and dy are not the same.
	private static final Size BOARD_SIZE = new Size(3,3);

	// This is a two-dimensional array that represents the board itself. The array's elements are Move enum objects, declared above.
	private static Move[][] board = new Move[BOARD_SIZE.width][BOARD_SIZE.height];

	// Also use a Move enum object to keep track of whose turn it is.
	private static Move whoseTurn;

	// Keep track of how many moves are left
	private static int movesLeft;

	private static Scanner inputScanner = new Scanner(System.in);

	public static void main(String... args) {
		while(true) {
			initGame();
			printBoard();

			while(movesLeft > 0) {
				Point move = askMove();
				makeMove(move);
				printBoard();
				Move winner = checkWin();
				if(winner != Move.NO_MOVE) {
					System.out.println("" + winner.moveChar() + " WINS!!!");
					break;
				} else if(movesLeft == 0) {
					System.out.println("It's a tie!!");
				}
			}


			if(!askPlayAgain()) {
				System.out.println("Thanks for playing!");
				break;
			}
		}
	}

	private static void initGame() {
		for(int y = 0; y < BOARD_SIZE.height; y++) {
			for(int x = 0; x < BOARD_SIZE.width; x++) {
				board[y][x] = Move.NO_MOVE;
			}
		}

		movesLeft = BOARD_SIZE.width * BOARD_SIZE.height;
		whoseTurn = Move.X_MOVE;
	}

	private static void printBoard() {
		for(int y = 0; y < BOARD_SIZE.height; y++) {

			for(int x = 0; x < BOARD_SIZE.width; x++) {
				// Print the contents of the board square
				Move m = board[y][x];
				if(m == Move.NO_MOVE) {
					System.out.print(squareNumberFromPoint(new Point(x, y)));
				} else {
					System.out.print(m.moveChar());
				}

				// print the vertical lines
				if(x != BOARD_SIZE.width - 1) {
					System.out.print("|");
				}
			}
			System.out.println("");

			// print the horizontal lines
			if(y != BOARD_SIZE.height - 1) {
				for(int x = 0; x < BOARD_SIZE.width; x++) {
					System.out.print("-");

					// print where the vertical and horizontal lines cross
					if(x != BOARD_SIZE.width - 1) {
						System.out.print("+");
					}
				}

				System.out.println("");
			}
		}
	}

	private static Point askMove() {
		while(true) {
			System.out.println("Enter " + whoseTurn.moveChar() + "'s move:");
			String s = inputScanner.nextLine();
			Scanner lineScanner = new Scanner(s);
			if(!lineScanner.hasNextInt()) {
			 	System.out.println("Please enter the number of the square to move to.");
			} else {
				int squareNumber = lineScanner.nextInt();
				Point p = pointFromSquareNumber(squareNumber);
				if(p.x < 0 || p.x > BOARD_SIZE.width - 1 || p.y < 0 || p.y > BOARD_SIZE.height - 1) {
					System.out.println("Illegal move. Try again.");
				} else if(board[p.y][p.x] != Move.NO_MOVE) {
					System.out.println("That square is already taken. Try again.");
				} else {
					return p;
				}
			}
		}
	}

	private static void makeMove(Point move) {
		board[move.y][move.x] = whoseTurn;
		movesLeft--;
		whoseTurn = whoseTurn == Move.X_MOVE ? Move.O_MOVE : Move.X_MOVE;
	}

	private static boolean askPlayAgain() {
		while(true) {
			System.out.println("Would you like to play again?");
			String response = inputScanner.nextLine();
			char c = '?';
			if(response.length() > 0) {
				c = response.toLowerCase().charAt(0);
			}
			if(c == 'y') return true;
			else if(c == 'n') return false;
			else System.out.println("Sorry, I didn't understand.");
		}
	}

	private static Move checkWin() {
		Move winner = Move.NO_MOVE;

		// check for vertical wins
		for(int x = 0; x < BOARD_SIZE.width; ++x) {
			winner = checkLine(new Point(x, 0), new Offset(0, 1), BOARD_SIZE.height);
			if(winner != Move.NO_MOVE) return winner;
		}

		// check for horizontal wins
		for(int y = 0; y < BOARD_SIZE.height; ++y) {
			winner = checkLine(new Point(0, y), new Offset(1, 0), BOARD_SIZE.width);
			if(winner != Move.NO_MOVE) return winner;
		}

		// check for diagonal wins
		winner = checkLine(new Point(0, 0), new Offset(1, 1), BOARD_SIZE.width); // This will crash if the board is not square
		if(winner != Move.NO_MOVE) return winner;

		winner = checkLine(new Point(BOARD_SIZE.width - 1, 0), new Offset(-1, 1), BOARD_SIZE.width); // This will crash if the board is not square

		return winner;
	}

	private static Move checkLine(Point startPoint, Offset direction, int distance) {
		Move winner = Move.NO_MOVE;
		Point curPoint = new Point(startPoint);
		for(int i = 0; i < distance; ++i) {
			if(i == 0) {
				winner = board[curPoint.y][curPoint.x];
				if(winner == Move.NO_MOVE) {
					// the first square we looked at had no move
					break;
				}
			} else {
				if(board[curPoint.y][curPoint.x] != winner) {
					// some subsequent square we looked at was not the same as the first square we looked at
					winner = Move.NO_MOVE;
					break;
				}
			}
			curPoint = curPoint.add(direction);
		}

		return winner;
	}

	private static Point pointFromSquareNumber(int squareNumber) {
		return new Point((squareNumber - 1) % BOARD_SIZE.width, (squareNumber - 1) / BOARD_SIZE.width);
	}

	private static int squareNumberFromPoint(Point p) {
		return p.y * BOARD_SIZE.width + p.x + 1;
	}
}
