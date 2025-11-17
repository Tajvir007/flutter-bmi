# BMI Calculator – Flutter (Module 13 Assignment)

A clean and fully functional **BMI Calculator App** built using Flutter.  
The app supports **multiple weight & height units**, performs correct conversions, calculates BMI, and displays the result using proper category & color indicators.

---

##  Features

###  Weight Input  
- Supports **kg** and **lb (pounds)**  
- Uses toggle/dropdown to switch units  
- Accepts decimal values (e.g., 70.5 kg)

###  Height Input  
- Supports **meters (m)**  
- **centimeters (cm)**  
- **feet + inches (ft/in)**  
- Auto inch carry (e.g., `5 ft 15 in → 6 ft 3 in`)  

###  Accurate Unit Conversion  
Used formulas:
kg = lb × 0.45359237
m = cm / 100
m = (feet × 12 + inch) × 0.0254

###  BMI Formula  


- Displays BMI with **1 decimal place** (e.g., 24.2)

---

##  BMI Categories & Colors

| Category      | Range           | Color  |
|---------------|------------------|--------|
| Underweight   | < 18.5          | Blue   |
| Normal        | 18.5 – 24.9     | Green  |
| Overweight    | 25 – 29.9       | Orange |
| Obese         | ≥ 30            | Red    |

The app shows category using a **Chip/Badge** and **colored Card background**.

---

## 🛡 Validation & UX

- No crashes on invalid or empty input  
- Shows SnackBar errors  
- Accepts decimal values  
- Auto height correction when inch ≥ 12  
- Clean, responsive UI  

---

##  Test Cases (Verified)

| Input | Result |
|-------|--------|
| 70 kg, 170 cm | BMI ≈ **24.2**, Normal (Green) |
| 155 lb, 5′7″ | BMI ≈ **24.3**, Normal (Green) |
| 95 kg, 165 cm | BMI ≈ **34.9**, Obese (Red) |

---

##  How to Run the App

1. Install Flutter SDK  
2. Clone the project:


