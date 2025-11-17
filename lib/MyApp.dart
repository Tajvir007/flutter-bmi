import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {


  // Controllers
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController(); // For m or cm
  final feetCtrl = TextEditingController();
  final inchCtrl = TextEditingController();

  // Unit Selections
  String weightUnit = "kg"; // kg or lb
  String heightUnit = "cm"; // m/cm/ft

  double? bmi;
  String? category;
  Color? categoryColor;

  // =============== Conversions ===============

  double poundsToKg(double lb) => lb * 0.45359237;

  double cmToMeters(double cm) => cm / 100;

  double feetInchToMeters(double ft, double inch) {
    return (ft * 12 + inch) * 0.0254;
  }

  // =============== Auto Inch Carry ===============
  void autoCarryInch() {
    if (inchCtrl.text.isEmpty) return;

    double inch = double.tryParse(inchCtrl.text) ?? 0;
    if (inch >= 12) {
      double extraFeet = (inch ~/ 12) as double;
      double remainingInch = inch % 12;

      feetCtrl.text = ((double.tryParse(feetCtrl.text) ?? 0) + extraFeet).toString();
      inchCtrl.text = remainingInch.toStringAsFixed(1);
    }
  }

  // =============== BMI CALC ===============
  void calculateBMI() {
    try {
      // Validate weight
      if (weightCtrl.text.isEmpty) {
        showError("Weight missing!");
        return;
      }

      double weight = double.parse(weightCtrl.text);

      // Convert weight to kg
      if (weightUnit == "lb") {
        weight = poundsToKg(weight);
      }

      // Convert height to meters
      double heightM = 0;

      if (heightUnit == "m") {
        if (heightCtrl.text.isEmpty) {
          showError("Height missing!");
          return;
        }
        heightM = double.parse(heightCtrl.text);
      }

      if (heightUnit == "cm") {
        if (heightCtrl.text.isEmpty) {
          showError("Height missing!");
          return;
        }
        heightM = cmToMeters(double.parse(heightCtrl.text));
      }

      if (heightUnit == "ft") {
        if (feetCtrl.text.isEmpty || inchCtrl.text.isEmpty) {
          showError("Feet & inch missing!");
          return;
        }
        double ft = double.parse(feetCtrl.text);
        double inch = double.parse(inchCtrl.text);
        heightM = feetInchToMeters(ft, inch);
      }

      if (heightM <= 0) {
        showError("Invalid height!");
        return;
      }

      // Final BMI
      double result = weight / (heightM * heightM);
      setState(() => bmi = result);

      // Category
      if (result < 18.5) {
        category = "Underweight";
        categoryColor = Colors.blue;
      } else if (result < 25) {
        category = "Normal";
        categoryColor = Colors.green;
      } else if (result < 30) {
        category = "Overweight";
        categoryColor = Colors.orange;
      } else {
        category = "Obese";
        categoryColor = Colors.red;
      }
    } catch (e) {
      showError("Invalid input!");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),

      ),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- Weight ----------------
              Text("Weight"),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: weightCtrl,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter weight",
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  DropdownButton(
                    value: weightUnit,
                    items: ["kg", "lb"]
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (v) => setState(() => weightUnit = v!),
                  )
                ],
              ),

              SizedBox(height: 20),

              // ---------------- Height ----------------
              Text("Height"),
              DropdownButton(
                value: heightUnit,
                items: ["m", "cm", "ft"]
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setState(() => heightUnit = v!),
              ),

              SizedBox(height: 10),

              if (heightUnit == "m" || heightUnit == "cm")
                TextField(
                  controller: heightCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  decoration: InputDecoration(
                    labelText: "Enter height ($heightUnit)",
                  ),
                ),

              if (heightUnit == "ft")
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: feetCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Feet"),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: inchCtrl,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        onChanged: (v) => autoCarryInch(),
                        decoration: InputDecoration(labelText: "Inch"),
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 30),

              // ---------------- Button ----------------
              Center(
                child: ElevatedButton(
                  onPressed: calculateBMI,
                  child: Text("Calculate BMI"),
                ),
              ),

              SizedBox(height: 30),

              // ---------------- Result ----------------
              if (bmi != null)
                Card(
                  color: categoryColor?.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "BMI: ${bmi!.toStringAsFixed(1)}",
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Chip(
                          label: Text(
                            category!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: categoryColor,
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        )
    );
  }
}
