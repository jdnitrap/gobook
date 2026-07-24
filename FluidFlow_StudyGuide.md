# Fluid Flow (TH06B) - Study Guide & Reference

## Course Overview
**Number:** TH06B | **Revision:** 10 | **Time Required:** 4.0 Hours  
**Program:** Operations | **Prerequisites:** None

This lesson discusses basic knowledge of fluid flow, how system changes affect fluid flow, hydraulic characteristics of fluid flow, and fluid flow losses due to system configuration changes.

---

## Key Definitions Summary

### Flow Measurements
- **Mass Flow Rate (ṁ):** Mass of fluid passing a point per unit time (lbm/hr)
  - Formula: ṁ = ρ × v × A
  - Where: ρ = density (lbm/ft³), v = velocity (ft/hr), A = area (ft²)

- **Volumetric Flow Rate (Q):** Volume of fluid passing a point per unit time
  - Units: gallons per minute (gpm) or cubic feet per minute (cfm)
  - Formula: Q = v × A
  - Relationship: ṁ = ρ × Q

- **Steady Flow:** Mass flow rate in equals mass flow rate out (ṁ₁ = ṁ₂)

### Fluid Properties
- **Viscosity:** Fluid's ability to resist flow
  - Standard: Water at 68°F = 1.0 centipoise
  - For liquids: ↑Temperature → ↓Viscosity
  - For gases: ↑Temperature → ↑Viscosity

- **Specific Gravity (SG):** Density ratio compared to water at 60°F
  - Water = SG 1.0
  - SG < 1 floats; SG > 1 sinks

- **Density:** Mass per unit volume
  - Water ≈ 62.4 lbm/ft³ (standard conditions)
  - Inverse of specific volume (v)

### Flow Types
- **Laminar Flow (NRe < 2,000):**
  - Smooth layers flowing over each other
  - Parabolic velocity profile
  - Lower head loss

- **Turbulent Flow (NRe > 3,500):**
  - Cross-currents disturb fluid layers
  - Flattened velocity profile
  - Higher head loss

- **Transitional (2,000 < NRe < 3,500):** Unstable, alternates

- **Reynolds Number:** Dimensionless indicator of flow type
  - Formula: NRe = (ρ × v × d) / μ

- **Single-Phase Flow:** Fluid is entirely liquid OR gas
- **Two-Phase Flow:** Mixture of liquid AND vapor (10-100× more resistance)

### Bernoulli's Equation Terms (Modified for Real Flow)
- **Elevation Head (z):** Potential energy due to height (feet)
- **Velocity Head (v²/2gc):** Kinetic energy due to motion (feet)
- **Pressure Head (Pv):** Pressure-volume energy (feet of fluid column)
- **Total Head:** Sum of all three terms (constant in ideal flow)
- **Pump Head (Hp):** Energy added by pump (feet)
- **Head Loss (Hf):** Energy lost to friction (feet)

### Head Loss Concepts
- **Head Loss:** Conversion of pressure/velocity to heat through friction
  - Expressed in feet of head
  - Increases internal energy (temperature) of fluid
  - Energy loss from flow standpoint, not total energy loss

- **Friction Factor (f):** Accounts for pipe roughness and flow type
  - Higher f → higher head loss
  - Depends on Reynolds number and pipe surface roughness

---

## Critical Equations

### Mass Flow Rate
```
ṁ = ρ × V̇ = ρ × v × A
ṁ = Q / v (specific volume)
```

### Volumetric Flow Rate
```
Q = v × A
```

### Continuity (Incompressible Fluid)
```
v₁ × A₁ = v₂ × A₂
```
When area increases, velocity decreases proportionally.

### Reynolds Number
```
NRe = (ρ × v × d) / μ
```
Determines laminar/turbulent/transitional flow.

### Bernoulli's Equation (Real Flow)
```
z₁ + v₁²/(2gc) + Pv₁ + Hp = z₂ + v₂²/(2gc) + Pv₂ + Hf
```

### Darcy's Equation (Head Loss)
```
Hf = f × (L/d) × (v²/(2gc))
```

**Factor Effects on Head Loss:**
- ↑ Friction factor (f) → ↑ Hf
- ↑ Pipe length (L) → ↑ Hf
- ↑ Pipe diameter (d) → ↓ Hf
- ↑ Velocity (v) → ↑ Hf exponentially (v²)

### Joukowsky Equation (Water Hammer)
```
ΔP = ρ × c × Δv
```
Peak pressure depends on velocity change and fluid density, NOT pipe length.

### Water Hammer Pulse Duration
```
Tpp = 2L / c
```
Longer pipes = longer pressure spike duration.

---

## How Factors Affect Head Loss

| Factor | Change | Effect on Hf |
|--------|--------|--------------|
| Pipe Length (L) | Increase | **INCREASES** |
| Pipe Diameter (d) | Increase | **DECREASES** |
| Fluid Velocity (v) | Double (2×) | **Quadruples** (4×) |
| Friction Factor (f) | Increase | **INCREASES** |
| Valve Position | Close (↑L/d) | **INCREASES** |
| Valve Position | Open (↓L/d) | **DECREASES** |

---

## Operator Control of System Behavior

### Throttle Valve Control
- **Closing valve** → increases L/d ratio → head loss increases
- **Opening valve** → decreases L/d ratio → head loss decreases

### Pump Speed Variation
- Head loss ∝ v² (exponential relationship)
- Double speed → quadruple head loss
- Speed control causes exponential changes in system performance

### Series vs. Parallel Piping
- **Series configuration** → increases head loss
- **Parallel configuration** → decreases head loss

---

## Temperature and Pressure Effects on Closed Systems

### Heating Effects
- **Liquids:** ↑Temperature → ↓Viscosity, ↓Specific Gravity → easier flow
- **Pressure increases** in closed system (confined volume)
- **NPSH decreases** (approaches saturation) → cavitation risk
- **Risk:** Isolated heat exchangers rupture if not cooled first

### Filling & Venting
- Fill to water-solid condition before startup
- **High-point casing vents** remove trapped air/gases
- **Keep vents open** until solid stream appears
- Prevents pump damage from cavitation and gas binding
- Prevents water hammer from sudden air pockets

### Draining Systems
- **Stop pumps and tag power** before draining
- **DON'T start pump** in drained system
- Risk: Cavitation, gas binding, metal-to-metal friction
- Ensure system refilled and vented before restart

---

## Water Hammer Prevention Methods

### System Preparation
1. ✓ Ensure systems water-solid before starting pumps
2. ✓ Open high-point casing vents (remove air)
3. ✓ Implement keep-fill systems for critical sections
4. ✓ Leave vents open until solid fluid stream

### Operational Procedures
1. ✓ **Initiate flow SLOWLY** when starting pumps
2. ✓ **Close valves SLOWLY** when stopping flow
3. ✓ Prevent hot steam in cool water systems
4. ✓ Prevent cold water in hot steam systems
5. ✓ Ensure steam traps function to remove condensate
6. ✓ Install drains at pipe low points

### System Design
1. ✓ Avoid long horizontal pipes (steam-water mixing risk)
2. ✓ Keep-fill capability on systems with large elevation differences
3. ✓ Drains at low points prevent water pocket accumulation
4. ✓ Proper valve materials and design reduce slam effects
5. ✓ Maintenance programs critical for valve performance

---

## Critical Relationships

### Velocity and Head Loss Relationship
Since Hf ∝ v²:
- Velocity increases 2× → Head loss increases 4×
- Velocity increases 3× → Head loss increases 9×
- Velocity increases 4× → Head loss increases 16×

**Operator Implication:** Small pump speed changes cause large system pressure changes.

### Temperature Effects on Flow
**For Liquids:**
- ↑ Temp → ↓ Viscosity (flows easier)
- ↑ Temp → ↓ Density
- ↑ Temp → ↓ Specific gravity
- Net effect: Less energy needed for flow

### Two-Phase Flow
- Head loss can increase 100× (0% to 100% quality)
- Causes pressure fluctuations → water hammer risk
- Flow oscillations difficult to control
- Temperature changes hard to manage

---

## Operating Experience Lessons

### OE22415 - Condensate Motor Bearing Failure
- **Cause:** High viscosity oil due to cold startup (52°F)
- **At startup temperature:** Oil viscosity ≈ 700 SUS
- **Effect:** Excessive friction → bearing pad contact with shaft
- **Result:** Bearing wipe, equipment damage
- **Lesson:** Understand viscosity-temperature relationship. Establish minimum bearing temperatures before startup.

### SER 16-96 - Reheater Drain Pipe Rupture
- **Cause:** Water hammer from system backflow
- **Result:** 18-inch pipe rupture, 7 personnel injuries
- **Lesson:** Water hammer can cause catastrophic failures
- **Key Issues:**
  - Operations didn't realize water hammer could rupture large pipe
  - Communication gaps on technical information
  - Procedures not updated before startup
  - Operating experience not adequately understood
  - Water hammer prevention modifications received insufficient priority

---

## Key Operator Competencies

### Knowledge Focus
✓ Understand component purpose, design, and operation
✓ Know how system changes affect fluid flow behavior
✓ Predict effects of valve/pump operation
✓ Verify expected results occur as predicted

### Monitoring Focus
✓ Know where pressure and flow indications are located
✓ Understand what proper operation looks like
✓ Verify parameters change as expected
✓ Question unexpected, out-of-ordinary, or abnormal conditions
✓ Don't allow changes that erode safety margins

### Control Focus
✓ Understand consequences of equipment operation
✓ Know which steps have undesirable consequences if not done correctly
✓ Always operate per approved procedures
✓ Maintain proper configuration control
✓ Reduce potential for operational events

### Safety Focus
✓ Water hammer can cause equipment damage and personnel injury
✓ Understand causes and prevention methods
✓ Follow all procedures, especially during startup/shutdown
✓ Report any water hammer events or pressure anomalies
✓ Never operate equipment unsafely to expedite operations

---

## Unit Conversions (Quick Reference)

**Pressure:** 1 psi = 0.0703 bar = 6.895 kPa  
**Velocity:** 1 ft/sec = 0.305 m/s  
**Temperature:** K = °C + 273.15; °R = °F + 459.67  
**Density:** 1 lbm/ft³ = 16.02 kg/m³

---

## Summary of 10 Learning Objectives

| Objective | Key Concept |
|-----------|------------|
| 1 | Mass and volumetric flow rate definitions and formulas |
| 2 | Fluid characteristics: viscosity, density, specific gravity |
| 3 | Laminar, turbulent, single-phase, two-phase flow types |
| 4 | Bernoulli's equation terms: elevation, velocity, pressure heads |
| 5 | Head loss definition and significance |
| 6 | Factors affecting head loss: pipe length, diameter, velocity |
| 7 | System characteristic curves: head loss vs. flow rate |
| 8 | Water hammer: definition and causes |
| 9 | Water hammer mechanisms, effects, and prevention methods |
| 10 | System operation: heating, filling/venting, draining effects |

---

## Testing Tips

✓ Focus on relationships between variables (not absolute values)
✓ Understand exponential nature of velocity's effect on head loss
✓ Know operator control points: valves, pump speed, system configuration
✓ Memorize key definitions but understand principles behind them
✓ Study operating experience cases carefully - lessons are often tested
✓ Know water hammer prevention methods thoroughly
✓ Understand temperature effects on closed systems

---

## References

- Fundamentals of Thermodynamics, Heat Transfer, and Fluid Flows, General Physics
- Thermal-Hydraulics Principles and Applications to PWR, Westinghouse
- DOE Fundamentals Handbook: Thermodynamics, Heat Transfer, Fluid Flow (June 1992)
- EPRI Report: Water Hammer Prevention, Mitigation, and Accommodation (NP-6766, Vol. 1-7)
- EPRI Video: Water Hammer Mechanisms
- INPO SER 16-96: Multiple Personnel Injuries from High Energy Reheater Drain Pipe Failure
- Station Operating Procedures and Technical Specifications
