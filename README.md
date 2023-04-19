# Automotive Expert System (Practice Project)

This practice project aims to help users learn and practice using the CLIPS rule-based programming language. 
The expert system is designed to diagnose simple problems with a car based on user inputs. 
The original version can diagnose issues related to starting, running, and performance of the engine. 
The updated version now includes additional maintenance checks to provide a more comprehensive diagnostic experience.

**Please note that this project is for educational purposes and should not be considered as professional advice for diagnosing and repairing vehicle issues. 
Always consult a professional mechanic for any automotive-related concerns.**

## New Features

### Extended Maintenance Checks: 
- The expert system now asks the user additional questions regarding various maintenance aspects of the vehicle when the engine starts and runs normally. These checks include:
        
        0. Oil level 
        1. Coolant level
        2. Transmission fluid level
        3. Brake fluid level
        4. Tire pressure
        5. Tire tread depth
        6. Air filter condition
        7. Windshield wiper fluid level
        8. Serpentine belt condition
        9. Dashboard warning lights

### Repair Suggestions for Maintenance Checks: 
- The system now provides repair suggestions based on the answers to the new maintenance checks. It offers guidance on how to address issues such as low fluid levels, abnormal tire pressure, worn-out tires, dirty air filters, and illuminated dashboard warning lights.

### Modified "Runs Normally" Rule: 
- The rule that asks if the engine runs normally has been modified to accept a third possible answer, "maybe", in addition to the original "yes" and "no" options. This change allows the user to provide a more nuanced response, and the system should be updated to handle the "maybe" answer in related rules.

##How to Use

To use the updated automotive expert system, you will need the CLIPS IDE, which can be downloaded from the following link: [CLIPS 6.40](https://sourceforge.net/projects/clipsrules/files/CLIPS/6.40/) 

Once you have the CLIPS IDE installed, follow these steps:

    1. Open the CLIPS IDE.
    2. Load the provided CLIPS code file.
    3. Always Reset and then run the expert system.
    4. The system will ask a series of questions to diagnose the vehicle's issues based on your responses. 
    5. Follow the prompts and answer each question to receive a suggested repair action to resolve the identified problem.
