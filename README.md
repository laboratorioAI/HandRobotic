# EMG-Controlled Robotic Arm with Myo and LEGO Mindstorms
This project aims to control a robotic arm using electromyographic (EMG) signals captured by the Myo Armband, which are reflected in the movements of a robotic arm built with LEGO Mindstorms. The system uses MATLAB as the platform to process the EMG signals and control the LEGO robot, performing movements based on gestures captured by the Myo Armband.

# Robotic Arm Movements
The robotic arm responds to a series of gestures made with the Myo Armband. The gestures are detected and interpreted to perform the following actions:

1. Wave In (Play/Pause):
- The Wave In gesture (moving the hand inward) activates or pauses the robotic arm's movement.
- If the arm is already moving, the gesture pauses the robot.

2. Wave Out (Stop Execution):
- The Wave Out gesture (moving the hand outward) stops the robotic arm's execution and pauses it.

3. Fist (Close Gripper):
- The Fist gesture (making a fist) closes the robotic arm's gripper.

4. Open (Open Gripper):
- The Open gesture (opening the hand) opens the robotic arm's gripper.

5. Pinch (Initial Position):
The Pinch gesture places the robotic arm in its initial position, serving as a reference point.

6. No Gesture or Unrecognized Gesture:
- If no gesture is detected or the gesture is unrecognized, the system indicates that no valid gesture was detected.

# Project Structure
The project is organized into several folders containing the necessary code and resources to run the system:

# EV3
Contains everything needed to control the LEGO Mindstorms EV3 robot from MATLAB:
- Lego ev3 Toolbox: A MATLAB toolbox that allows sending commands to the EV3 from MATLAB.
- modelos rearmado Lego: LEGO Digital Designer software files for reassembling the robotic arm.
- robot3GDL.ev3: Framework to control the robotic arm in LEGO Mindstorms Education EV Teacher Edition.

# MATLAB
Contains the code and functions in MATLAB needed to interact with the system and control the robot:
- GUI: Functions and figures dependent on the graphical user interface.
- images: Contains the images for the 6 classes recognized by the gesture recognition system.
- scripts & Functions: Contains the scripts and functions that implement the logic to control the robotic arm based on the EMG signals.

# Myo mex
A library that compiles a C++ function as a MEX function to enable communication between MATLAB and the Myo Armband.
Myo mex is added with the complied mex function for win64.

# usersData
Contains the data saved during the training routine of the gesture recognition system. This folder stores the EMG signals used to train the model.

# Requirements
Before running the project, make sure you have the following installed:
- MATLAB: Required to run the entire system and control the robotic arm.
- LEGO Mindstorms EV3: You will need the LEGO Mindstorms EV3 hardware to build and control the robotic arm.
- Myo Armband: The device that captures the EMG signals.
- MyoMex Library: Ensure it is correctly compiled to allow communication between MATLAB and the Myo Armband.

Additionally, the following MATLAB toolboxes must be installed:

Navigation Toolbox
Robotics System Toolbox
UAV Toolbox
Parallel Computing Toolbox
Instrumentation and Control Toolbox