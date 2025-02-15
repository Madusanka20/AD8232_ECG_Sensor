# 📡 ECG Monitoring using AD8232 Sensor, ESP32 & MATLAB  

## 📌 Project Description  
This project demonstrates how to acquire **ECG signals** from the **AD8232 ECG sensor** using an **ESP32** and visualize the data in **MATLAB** for real-time monitoring, filtering, and analysis.  

---

## 🛠️ Components Required  

- **AD8232 ECG Sensor Module**  
- **ESP32**  
- **Electrode Pads**  
- **Jumper Wires**  
- **Computer with MATLAB & ESP32 Support**  

---

## ⚡ Circuit Connections  

| AD8232 Pin | ESP32 Pin |
|------------|------------|
| **GND**    | GND        |
| **3.3V**   | 3.3V       |
| **OUTPUT** | GPIO36 (VP) |
| **LO-**    | GPIO34     |
| **LO+**    | GPIO35     |

> **Note:** Attach the electrode pads as follows:  
> - **RA (Right Arm)** → Right wrist  
> - **LA (Left Arm)** → Left wrist  
> - **RL (Right Leg - Ground Reference)** → Near right ankle  


