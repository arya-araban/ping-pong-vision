import subprocess
import time

import cv2

FPS = 30.0  # max is 30FPS
NUM_FRAMES = 125
FRAME_RECORD = 1  # default should be 1


# number of frames recorded will be NUM_FRAMES/FRAME_RECORD


def capture_video(cn1, cn2):
    # Define the codec and create VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'DIVX')
    out1 = cv2.VideoWriter('./webcam/outputs/output1.avi', fourcc, FPS, (640, 480))
    out2 = cv2.VideoWriter('./webcam/outputs/output2.avi', fourcc, FPS, (640, 480))

    cap1 = cv2.VideoCapture(cn1)
    cap2 = cv2.VideoCapture(cn2)
    ct = 0
    while ct != NUM_FRAMES:

        ret1, img1 = cap1.read()
        ret2, img2 = cap2.read()

        if ret1 and ret2:
            if ct % FRAME_RECORD == 0:
                out1.write(img1)
                out2.write(img2)
            # cv2.imshow('img1', img1)
            # cv2.imshow('img2', img2)

            k = cv2.waitKey(1)
            # if k == 27:  # press Esc to exit
            #     break
        ct += 1

    cap1.release()
    cap2.release()

    out1.release()
    out2.release()

    cv2.destroyAllWindows()


def merge_video(vid1, vid2, output):
    command = f"ffmpeg -i '{vid1}' -i '{vid2}' -filter_complex hstack -c:v ffv1 '{output}'.avi"
    subprocess.call(command, shell=True)
    # merge_video('./webcam/outputs/output1.avi', './webcam/outputs/output2.avi', './webcam/outputs/merged')


def main():
    time.sleep(2)
    capture_video(0, 1)


if __name__ == "__main__":
    main()
