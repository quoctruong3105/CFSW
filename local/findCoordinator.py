import cv2
import SikuliXLibrary

# Load the image
image = cv2.imread('E:/CFSW/local/template/screenshot_5.png')

# Set the desired window resolution (width and height)
desired_width = 1920
desired_height = 1080

# Resize the image to the desired resolution
resized_image = cv2.resize(image, (desired_width, desired_height))

# Display the image and capture click events
def click_event(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        print(f"Clicked at: ({x}, {y})")

# Show the resized image
cv2.imshow('image', resized_image)
cv2.setMouseCallback('image', click_event)
cv2.waitKey(0)
cv2.destroyAllWindows()
