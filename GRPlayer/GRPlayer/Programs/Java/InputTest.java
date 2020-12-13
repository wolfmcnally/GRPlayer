package bigpix.examples;

import bigpix.*;

public class InputTest extends BigPix.Program {

	public static void main(String... args) {
		BigPix.start(new InputTest());
	}

	public void run() {
		boolean lastButtonDown = false;
		Point lastMousePos = new Point(-1, -1);
		String lastKeysTyped = "";
		String lastKeysDown = "";

		while(true) {
			boolean paintPixel = false;

			boolean buttonDown = isButtonDown();
			if(buttonDown != lastButtonDown) {
				System.out.println("Button down: " + buttonDown);
				lastButtonDown = buttonDown;

				if(buttonDown) {
					setPenColor(Random.randomColor());
					paintPixel = true;
				}
			}

			Point mousePos = getMousePosition();
			if(!mousePos.equals(lastMousePos)) {
				System.out.println("Mouse position: " + mousePos);
				lastMousePos = mousePos;

				if(buttonDown) {
					paintPixel = true;
				}
			}

			if(paintPixel) {
				setPixel(mousePos);
				flush();
			}

			String keysTyped = getKeysTyped();
			if(!keysTyped.equals(lastKeysTyped)) {
				System.out.println("Keys:" + keysTyped);
				lastKeysTyped = keysTyped;

			}

			String keysDown = getKeysDown();
			if(!keysDown.equals(lastKeysDown)) {
				System.out.println("Keys down:" + keysDown);
				lastKeysDown = keysDown;

				if(isKeyDown("Escape")) {
					erase(Color.BLACK);
					flush();
					clearKeysTyped();
				}
			}
		}
	}
}
