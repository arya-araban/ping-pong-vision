import time

import cv2


def capture_img(cn1, cn2):
    cam1 = cv2.VideoCapture(cn1)
    cam2 = cv2.VideoCapture(cn2)
    if cam1.isOpened():
        count = 0
        while True:
            count += 1
            s1, img1 = cam1.read()
            s2, img2 = cam2.read()
            picName1 = f'C{cn1}_pic{count}.png'
            picName2 = f'c{cn2}_pic{count}.png'
            if count % 50 == 0:
                cv2.imwrite(f"./c{cn1}/{picName1}", img1)
                cv2.imwrite(f"./c{cn2}/{picName2}", img2)

    cam1.release()
    cam2.release()


def main():
    time.sleep(2)
    capture_img(0, 1)


if __name__ == "__main__":
    main()
