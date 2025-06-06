import time
import winsound  # For Windows sound, you can use 'winsound', for Linux you may need to use other libraries like 'pygame'

def set_alarm():
    # Ask the user for the alarm time in 24-hour format
    alarm_time = input("Enter the time for alarm (in HH:MM format): ")

    while True:
        # Get the current time in HH:MM format
        current_time = time.strftime("%H:%M")
        
        # Print current time to let the user know
        print(f"Current time: {current_time}", end="\r")
        
        # Check if the current time matches the alarm time
        if current_time == alarm_time:
            print("\nTime to wake up!")
            # Play a beep sound (we can change this to a custom sound file or alert)
            winsound.Beep(1000, 1000)  # Frequency 1000 Hz for 1 second
            break
        
        # Sleep for 60 seconds before checking the time again
        time.sleep(60)

# Run the alarm clock
set_alarm()
