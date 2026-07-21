# BNT-TH05 – Thermodynamic Cycles

**Title:** Thermodynamic Cycles  
**Number:** TH05B  
**Revision:** 04c  
**Program:** Operations  
**Time Required:** 3.0 hours  
**Prerequisites:** None  

---

## Overview
In this lesson we will look at two different cycles and analyze them to understand the limitations imposed by the Second Law of Thermodynamics. This lesson examines both the limits on cycle efficiency and what can be done to maximize the efficiency.

---

## Objectives

### Enabling Objectives
1. Describe a thermodynamic cycle (including the essential elements of a cycle).
2. Describe the difference between a process and a cycle.
3. Define thermodynamic cycle efficiency (η) in terms of net work produced, heat supplied, and heat rejected.
4. Describe the Carnot cycle and the relevancy of the Carnot cycle efficiency to power plant design and operation.
5. Calculate the Carnot efficiency of a thermodynamic cycle when given heat source and heat sink temperature.
6. Describe the impact that the Second Law of Thermodynamics has on power plant design and operation.
7. Describe the differences between a Rankine steam cycle and a Carnot cycle.
8. Describe how each of the following affects Rankine cycle efficiency:
   - A. Superheating
   - B. Moisture Separators/Reheaters
   - C. Feedwater Heating
   - D. Condenser Vacuum
   - E. Condensate Subcooling
   - F. Steam Pressure
   - G. Steam Quality
9. Define condensate depression.
10. Describe methods of operation that aid in maintaining unit efficiency.

---

## 1.0 Introduction

The fundamental concept of electric power generation is the same for a nuclear power plant as for a conventional power plant. In both, energy in the form of heat is transferred to the working fluid, which is then passed through a turbine where energy is extracted in the form of work done to rotate a generator which converts this energy to electricity.

When the working fluid of a system goes through different changes of state, or processes, and then returns to its initial state, it is said to have undergone a **cycle**. The properties of the working fluid are the same at the beginning and end of the cycle.

**Thermodynamic cycle** = a recurring series of thermodynamic processes used for the transformation of energy to produce a useful effect.

---

## 2.0 Thermodynamic Cycle

### Essential Elements of a Thermodynamic Cycle
1. A working fluid
2. An engine for conversion of heat energy to work
3. A heat source (high-temperature energy reservoir)
4. A heat sink (low-temperature energy reservoir)
5. A device to move the working fluid (e.g., pump, thermal driving head, etc.)

### Cycle Efficiency
The Second Law states that no heat engine, actual or ideal, when operating in a cycle can convert all the heat supplied to it into mechanical work.

Some of the heat supplied (Q<sub>A</sub>) must be rejected as heat (Q<sub>R</sub>). The difference is the net work produced (W<sub>NET</sub>).

**Cycle Efficiency (η):**

\[
\eta = \frac{W_{NET}}{Q_A} = \frac{Q_A - Q_R}{Q_A} = 1 - \frac{Q_R}{Q_A}
\]

---

## 3.0 Carnot Cycle

The Carnot cycle is an ideal heat engine that converts heat into work through reversible processes. It has the **highest possible thermal efficiency** for a heat engine operating between given heat source and heat sink temperatures.

### Processes
- Two ideal isothermal processes
- Two ideal adiabatic (isentropic) processes

### Carnot Efficiency Formula

\[
\eta_{Carnot} = 1 - \frac{T_R}{T_A} = \frac{T_A - T_R}{T_A}
\]

Where temperatures are in absolute units (Rankine or Kelvin).

**Key Point:** Efficiency depends **only** on the absolute temperatures of the heat source (T<sub>A</sub>) and heat sink (T<sub>R</sub>).

### Ways to Increase Carnot Efficiency
1. Increase the temperature of the heat source
2. Decrease the temperature of the heat sink

**Example Calculation**  
Heat source = 540°F, Heat sink = 60°F  

Convert to Rankine:  
T<sub>A</sub> = 540 + 460 = 1000°R  
T<sub>R</sub> = 60 + 460 = 520°R  

\[
\eta = 1 - \frac{520}{1000} = 0.48 = 48\%
\]

---

## 4.0 Rankine Cycle

The Rankine cycle more closely approximates real steam power plant processes than the Carnot cycle.

### Processes
- 4→1: Isentropic compression (ideal pump)
- 1→2: Constant pressure heat addition (boiler)
- 2→3: Isentropic expansion (ideal turbine)
- 3→4: Constant pressure heat rejection (condenser)

### Efficiency Expressions
- Boiler: Q<sub>A</sub> = h<sub>2</sub> − h<sub>1</sub>
- Turbine: W<sub>T</sub> = h<sub>2</sub> − h<sub>3</sub>
- Condenser: Q<sub>R</sub> = h<sub>3</sub> − h<sub>4</sub>
- Pump: W<sub>P</sub> = h<sub>1</sub> − h<sub>4</sub>

\[
\eta_{Rankine} = \frac{(h_2 - h_3) - (h_1 - h_4)}{h_2 - h_1}
\]

---

## 5.0 Factors Affecting Rankine Cycle Efficiency

| Factor                      | Effect on Efficiency                  | Primary Reason |
|----------------------------|---------------------------------------|--------------|
| **Superheating**           | Increases                             | More net work produced; higher quality steam reduces turbine losses |
| **Moisture Separator Reheater (MSR)** | Minor / neutral (may ↑ or ↓) | Primary purpose is **blade protection**, not efficiency |
| **Feedwater Heating**      | Increases                             | Less heat must be added by the reactor |
| **Higher Condenser Vacuum** (lower absolute pressure) | Increases | More work extracted from steam + less heat rejected |
| **Condensate Depression**  | Decreases as depression increases     | Extra heat must be re-added later |
| **Higher Steam Pressure / Temperature** | Increases                    | Lower entropy at turbine inlet → less heat rejected |
| **Higher Steam Quality**   | Increases                             | More enthalpy available to do work |

### Condensate Depression (Objective 9)
Condensate depression = T<sub>sat</sub> − T<sub>hotwell</sub>  

Some subcooling is required for condensate pump NPSH, but excess depression reduces efficiency.

---

## 6.0 Operational Considerations (Objective 10)

Ways operators can help maintain high unit efficiency:
- Minimize unnecessary auxiliaries
- Minimize steam generator blowdown
- Fix steam leaks
- Fix air in-leakage into the condenser
- Recover heat from air ejector condensers, gland seal condensers, and blowdown heat exchangers
- Operate near full load when possible (design point)

**Heat Rate** = energy input (BTU) required per kW-hr of electrical output.  
Heat rate is **inversely** related to efficiency.

---

## Summary Table – Effects on Rankine Cycle Efficiency

| Condition                    | Effect          | Discussion |
|-----------------------------|-----------------|----------|
| Superheating                | More efficient  | Increased heat added results in more net work |
| MSR                         | Minor effect    | Main benefit is LP turbine blade protection |
| Feedwater Heating           | More efficient  | Less heat must be added by the reactor |
| Higher Condenser Vacuum     | More efficient  | Higher net work + lower heat rejection |
| Minimal Condensate Depression | More efficient | Reduces both Q<sub>R</sub> and required Q<sub>A</sub> |
| Higher Steam T / P          | More efficient  | Lower turbine exit entropy → less heat rejected |
| Higher Steam Quality        | More efficient  | More enthalpy available for work |

---

*Lesson material extracted and formatted by Grok for study use.*
