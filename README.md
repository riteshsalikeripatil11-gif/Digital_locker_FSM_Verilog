🔐 Digital Locker using Finite State Machine (Verilog HDL)

📌 Project Overview
This project implements a secure Digital Locker system using a synchronous Finite State Machine (FSM) in Verilog HDL.
The design was developed and simulated using Xilinx Vivado and verified through behavioral simulation waveforms.
The system supports password authentication, data storage, lockout protection after multiple failed attempts, tamper detection, and timeout-based recovery.

✨ Key Features
4-digit PIN authentication
Secure unlock mechanism
Data storage and retrieval
PIN update functionality
Lockout after 3 incorrect attempts
Automatic lockout timeout recovery
Tamper detection support
Fully simulated in Xilinx Vivado

🧠 FSM Architecture
The system is implemented using a synchronous FSM with clearly defined states.
States:
IDLE – Waiting for user interaction
ENTERING – Capturing 4-digit PIN input
VERIFY – Comparing entered PIN with stored PIN
UNLOCKED – Access granted
ERROR – Incorrect PIN entered
LOCKOUT – Security lockout state

State Diagram

<img width="753" height="370" alt="state_diagram" src="https://github.com/user-attachments/assets/6feae1d0-2ac3-4701-a21a-4593db387a4d" />

🔐 Security Mechanism
Wrong attempts are tracked using a counter.
After 3 incorrect PIN entries, the system transitions to LOCKOUT.
During LOCKOUT:
Access is denied
Fail signal remains active
Timeout counter runs
After timeout completion, system returns to IDLE automatically.
Tamper signal forces immediate lockout for enhanced security.

💾 Data Storage Functionality
When in the UNLOCKED state:
User can store 4-digit data
Stored data can be read using the read signal
PIN can be updated using the set_pin signal

📊 Simulation Results (Vivado Behavioral Simulation)

Waveform Output

<img width="1631" height="1078" alt="waveform" src="https://github.com/user-attachments/assets/a0675053-b7c4-4a64-8f48-9e7cbdae0b97" />


Waveform Analysis

<img width="738" height="563" alt="waveform_analysis" src="https://github.com/user-attachments/assets/9cfdfa8a-ee34-4a15-92ef-f458f614b50b" />

Simulation verifies:
Correct PIN unlocks system
Incorrect PIN triggers ERROR
Three wrong attempts activate LOCKOUT
Automatic recovery from LOCKOUT
Proper data storage and read operations

📂 Project Structure
Digital-Locker-FSM/
│
├── src/
│   └── locker.v          # Main RTL design
│
├── sim/
│   └── tb.v              # Testbench
│
├── docs/
    ├── state_diagram.png
    ├── waveform.png
    └── waveform_analysis.png


🛠 Tools Used
Verilog HDL
Xilinx Vivado (Behavioral Simulation)
GTKWave (Optional external waveform viewer)

🚀 How to Run Simulation in Vivado
Create a new RTL project in Vivado
Add locker.v under Design Sources
Add tb.v under Simulation Sources
Run Behavioral Simulation
Observe waveform results

🎯 Learning Outcomes
FSM design using Verilog HDL
Secure lockout implementation using counters
Proper separation of sequential and combinational logic
Testbench design and functional verification
Behavioral simulation using Vivado

👨‍💻 Author
Ritesh Salikeri Patil
Electronics and Communication Engineering Student
