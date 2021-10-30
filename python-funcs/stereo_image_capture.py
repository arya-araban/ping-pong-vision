import time

import cv2


def capture_img(cam_index_1, cam_index_2, frame_delay):
    """This function captures images from two cameras at roughly the same time.

    cam_index_1 - The index of the first camera connected to the PC
    cam_index_2 - The index of the second camera connected to the PC
    frame_delay - the number of frames delayed between taking images

    the images will be saved into folders c{cam_index_1}, and c{cam_index_2}
    """
    cam1 = cv2.VideoCapture(cam_index_1)
    cam2 = cv2.VideoCapture(cam_index_2)
    if cam1.isOpened() and cam2.isOpened():
        count = 0
        while True:
            count += 1
            s1, img1 = cam1.read()
            s2, img2 = cam2.read()
            picName1 = f'C{cam_index_1}_pic{count}.png'
            picName2 = f'c{cam_index_2}_pic{count}.png'
            if count % frame_delay == 0:
                cv2.imwrite(f"./c{cam_index_1}/{picName1}", img1)
                cv2.imwrite(f"./c{cam_index_2}/{picName2}", img2)

    cam1.release()
    cam2.release()


def main():
    time.sleep(2)
    capture_img(0, 1, frame_delay=50)


if __name__ == "__main__":
    main()
