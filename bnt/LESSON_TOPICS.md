# Lesson Topics

## TH01
- Systems of Measurement
- System Types
- Pressure Concepts
- Pascal's Law
- Density and Specific Volume

## TH02
- First Law
- Stored vs Transient Energy
- PE, KE, U, PV, Q, W
- H = U + PV
- h = u + Pv
- Delta h = q - w
- Improvement Area: equations and symbols

## TH04
- Adiabatic, Isobaric, Isentropic, Isenthalpic, Isothermal
- Heat Exchanger: q = hout - hin
- Turbine: WT = hin - hout
- Pump: WP = hout - hin
- Throttle: hin = hout
- Condensate Depression = Tsat - Tcondensate
- Missed Concepts: Condensate Depression, Condenser Terminology

## CP01
- Piping
  - Purpose: housing to transport fluids (and sometimes fluid/solid mixtures) between equipment
  - Design factors: fluid temperature, fluid pressure, flow rate/velocity, chemical properties, physical properties, contamination, shock loads (water hammer, steam hammer, thermal shock, seismic), changes in direction
  - Materials: low-carbon steel (cheap, rusts easily), low-alloy steel (high-temp, more wear/fatigue/corrosion resistant), stainless steel (corrosion resistant, used where corrosion product buildup must be minimized), copper alloys (corrosion resistant, good conductivity), nickel alloys (high temp/pressure, high cost), plastic (corrosion resistant, lightweight)
  - Supports/restraints: rigid restraints, spring hangers (vertical gravity loading), snubbers (limit seismic motion, allow thermal growth)
  - Thermal effects: thermal loops/bends, piping expansion joints, thermal insulation
- Valve Functions
  - Five principal functions: starting/stopping flow, throttling flow, controlling direction of flow, regulating pressure, relieving pressure
  - Basic construction: body, bonnet, disk, seat rings, stem
  - Backseat: removes system pressure from the packing; allows packing replacement at normal system pressure
  - Packing/stuffing box: compression packing seals around the stem to prevent leakage
  - Rising stem vs. non-rising stem valve designs
- Valve Types
  - Gate valve: isolation only, poor for throttling, low D/P when open
  - Globe valve: good throttling ability (disk seats at near-right angles to flow), higher D/P even when open
  - Kerotest valve: pack-less globe valve, ~1.25 turns full open to full closed, avoid over-torquing (can crush the disk)
  - Needle valve: fine/precise flow adjustment via a long cone-shaped stem tip, poor isolation valve
  - Butterfly valve: large diameter/high flow/low pressure service, soft resilient seat, over-torque can damage the seat
  - Plug and ball valves: stop/start only, quick-acting, minimal D/P effect on torque, cannot regulate flow
  - Diaphragm valve: used for radioactive/corrosive fluids, fluid fully separated from moving parts, zero stem leakage
  - Check valves: swing check (hinged disk), lift check (globe-like body, higher D/P), stop check (can also be forcibly closed by an actuator, like a combined check + globe valve)
  - Relief valve: opens gradually as pressure rises past setpoint (accumulation); mainly used on liquid systems
  - Safety valve: pops fully open at setpoint with little/no accumulation, closes at blowdown; mainly used on steam/gas systems
  - Vacuum breaker: opposite of a relief device -- protects a vessel from collapsing under low internal pressure
  - Steam traps: remove condensate from steam lines while preventing steam loss -- bellows-type (volatile liquid expansion), thermostatic/impulse (flashing to steam based on pressure differential), bucket-type (float-operated)
- Actuators
  - Failure positions: Fail Open, Fail Closed, Fail As Is (most associated with MOVs), Fail Safe (the position required to protect the system/equipment)
  - Manual actuators: handwheel/lever, sometimes with reach rods or gearing for mechanical advantage
  - Electric actuators: Motor Operated Valves (MOVs, fail as-is, gear reduction, declutch lever for manual/motor engagement) and Solenoid Operated Valves (fail position set by spring placement)
  - Pneumatic actuators: gas cylinder, gas piston, gas diaphragm, gas vane (quarter-turn valves) -- fail position set by spring action on loss of gas pressure
  - Hydraulic actuators: piston-driven, fail position set by spring action on loss of hydraulic pressure
  - Valve controller: automatic mode repositions the valve to maintain a sensed parameter; manual mode gives the operator direct remote control
- Valve Position Verification
  - Light indication: red = open, green = closed, both lit = mid-position/throttled/stroking
  - Travel indication: rising stem position, local mechanical pointer
  - System indication: senses (touch/sound/sight), correct number of handwheel turns, visible stem, attempting to move a valve closed to verify shut, attempting to move a valve closed to verify open (never open a valve to "check" it open)
  - Quarter-turn valves (butterfly/plug): lever parallel to piping = open, lever perpendicular to piping = closed
  - Human error prevention in valve mispositioning: verify all local/remote indications reflect actual plant conditions before and after manipulation; follow procedures and independent verification; verify valves and instrumentation are labeled correctly
- Thermal Binding
  - Occurs when the valve body cools faster than the disk, causing differential thermal contraction that binds the seat against the disk, potentially making the valve impossible to reopen until reheated
  - Prevention: crack the valve open and re-shut periodically during cooldown; use proper closing torque
- Pressure Locking
  - Occurs when liquid becomes trapped in the valve bonnet and pressurizes as it heats, preventing the valve from opening
  - Prevention: use a relief or vent path on the valve bonnet to equalize/reduce pressure build-up
- Operating Experience (de-identified lessons)
  - Valve wrenches must never be used on a motor operated valve (MOV) handwheel to gain extra mechanical advantage -- the added leverage can overstress the actuator gearing/casing and has caused catastrophic actuator failure
  - When manually operating a valve, reaching a hard stop on the handwheel does not by itself confirm the valve reached its true fully open or fully closed position -- verify it traveled its full designed number of turns
  - Manually operating certain motor-actuated valves past their designed open limit can slip the position limit switch, so a leak rate/stroke time retest is required any time such a valve is manually operated
