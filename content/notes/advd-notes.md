+++
title = "Analog and Digital VLSI Design"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 28.1 (Org mode 9.6 + ox-hugo)"
+++

## Radio Spectrum {#radio-spectrum}

-   Used for communication initially
-   Wireless communication
-   Radio Spectrum is divided into frequency bands which are allocated to certain services.
-   The band is subdivided into channels that are used for particular transmission.
-   The wider the frequency bands and the channel, the more information that can be passed through them.

    | Frequency             | Use                        |
    |-----------------------|----------------------------|
    | VLF                   | Maritime Navigation        |
    | LF                    | Maritime Navigation        |
    | MF                    | AM Radio                   |
    | HF                    | Shortwave Radio            |
    | VHF (30-300 MHz)      | TV, FM Radio               |
    | UHF (300 MHz - 3 GHz) | TV, Mobile, GPS, Wi-FI, 4G |
    | SHF                   | Satellite                  |
    | EHF                   | Radio Astronomy            |
-   LF Bands provide wider coverage due to **high penetration power** but they have **poor capacity** (carry less information).
-   HF bands have greater capacity but less wider coverage.
-   Cell phones are multi-band device, when one's closer to a radio tower/station, it uses HF bands, but at poor reception they fall back to LF bands (GSM: 900-1800 MHz).
-   Wireless networks cover large amounts of area via a number of low-power radio stations laid out in hexagonal, cell-like grids.
-   Cellular commuication works by transmitting analog voice/data after amplification and conversion to digital bits into the environment and then received by selecting the corresponding frequency (highly selective network), processing the data (noise removal etc) and then converting back to analog audio. This process is know as modulation-demodulation.

{{< figure src="/ox-hugo/advd-rf-tran.png" >}}

-   Elements of a transceiver: _Oscillators, phase-clocked loops, frequency synthesizers, converters, filters, power circuits_ having **high data rate, resolution, less cost and energy per conversion**.


## FIXME VLSI Design - An Overview {#fixme-vlsi-design-an-overview}

-   **Moore's Law:** Number of components (transistors) in ICs would double every two years. This was possible because of _scaling_.

{{< figure src="/ox-hugo/advd-moore-law.png" >}}

-   Learn how to convert schematic into a layout and vice-versa.
-   First microprocessor from intel - 4004, 8 bit
-   FPGA: Customizable pre-fabricated design
-   VLSI Design Styles


## Fabrication {#fabrication}

-   Sequence of steps that are followed to get a silicon chip with different patterns
-   Clean room: Class 1 = 1 dust particle in 1 ft<sup>3</sup>
-   VLSI Design flow:
    Functional Description (Verilog) &rarr; Circuit Design &rarr; Layout &rarr; Masks (Patterns)
-   Twin-tub process: For p-mos, there's an n-well and vice versa.
-   [Simplified-CMOS-Process.jpg]
-   CVD: Growing Field Oxide and gate oxide
-   Lithography: Process of patterning the silicon
-   Why Si over Ge? Band gap Si&gt;Ge, Ge can't be used in mass production due to lack of raw material also SiO_2 is highly stable whereas GeO is soluble in water.
-   Getting that wafer:
    Sand &rarr; SiO_2 &rarr; Metallurgical Grade Si (99.9% Pure) &rarr; CZ Chamber (1000^o C) &rarr; Seed Crystal + Molten Si &rarr; Si crystal ingot &rarr; Diamond saw &rarr; Polishing &rarr; Silican Wafer
-   Dopants are introduced in the CZ chamber via _diffusion/ion implantation_, n-type: B (Pentavalent), p-type: P(Trivalent)
-   Diffusion:
    Temperature is around 650 C, Carrier made of quartz, Dopant in either crystal or powdered form, preheating temperature slightly lower than furnace, carrier gas carries the dopant vapours onto the silicon wafer by getting into the vacant sites of lattice defects and when they move from interstitional locations to lattice positions, doping is complete.
-   Fick's Law: Determines the amount of dopant required, diffusion temperature and the duration of the diffusion.
-   Ion Implantation:
    Source of the dopants are in ionic (charged) form, so an ion source releases a beam of ions which is columated by lenses to a small spot size called aperture, this accelerated beam of ions hits the silicon surface and the bombardment results in dislodging of Si atoms from the lattice, and the broken bonds are healed and dopant settling is done via _annealing_ (heating of wafer post-implantation).
-   Deposition:
    Used to deposit different materials from SiO_2 to metals, it can be achieved either chemically or physically. CVD is similar to diffusion whereas PVD is akin to ion implantation.
-   For metal deposition, generally MCl_2 are used since on reaction with hydrogen (carrier) it forms HCl which is a volatile by-product that can be easily disposed of.
-   One of the simplest PVD methods called sputtering in which a sputtering target block made out of the metal to be deposited is held and a highly non-reactive Ar^+ ionic sputtering gas is directed onto the target by creating a potential difference, this causes bombardment of the ions onto the target and results in dislodging of parts of target material which are deposited onto the substrate.


## Lithography {#lithography}

-   Stone + Write: Process of creating patterns on the Si wafer, analogous to stenciling. The ink is _light of a particular wavelength_, the stencil is a mask (quartz plate) and a resist (polymer that reacts with light).
-   The **mask** has opaque and transparent regions which are created by coating it with Chromium. In the transparent regions, the light falls over the Si substrate and interacts with the resist.
-   **Resist** can be of two kinds, the positive resist softens on interaction with light and the softened material can be removed by a particular solvent and the area unexposed to light stays intact whereas the negative resist hardens on interaction so the uninteracted material can be removed by the solvent.
-   After the pattern is created on the resist, it can be transferred over to the Si substrate either by additive or subtractive process and acetone removes the posres and all that's left is the deposited material (Al) in case of additive process whereas in the subtractive process a chemical etchent (KOH) is used to etch out the area not protected by the posres and acetone removes the resist.
-   Negative resist better for etching since hardening makes for stronger withold over removal process.
-   Diffraction Limit (Fresnel diffraction) limits the minimum feature size that can be achieved by lithography, Rayleigh limit. For smaller wavelength lights, the limit is smaller and vice-versa. (Why are 7nm gate sizes common?)
-   Epitaxy: Growing highly pure Si by using underlying Si crystal as substrate which reduces the large number of defects thereby improving mobility. When the underlying substrate and the material to be grown is the same (matching lattice structure), homoepitaxy is under play and for heteroepitaxy (HBT) the lattice structure aren't same (GeAs etc).
-   Through epitaxy, one can have a lightly doped layer over highly doped layer which is not possible with diffusion/ion implantation. It is achieved by MOCVD (Metal Organic CVD).
-   nMOS fabrication: Pure Si Crystal + (Si+Dopant) Melt &rarr; Thick \\(SiO\_2\\) deposited over surface (FO) &rarr; Deposit Photoresist (for pattern creation) &rarr; Photoresist exposed to UV through mask &rarr; Remove unpolymerised photoresist &rarr; Etch \\(SiO\_2\\) via HF acid, then remove unpolymerised photoresist &rarr; Add gate oxide then polysilicon via CVD &rarr; Again coat with resist and and pass UV, then etch out unexposed area &rarr; Remove resist and polysilicon gate is created &rarr; Diffusion/Ion-implantation to form source and drain (Self-aligned process) &rarr; Grow a thick layer of \\(SiO\_{2}\\) again for creating metal contact &rarr; Photoresist  and masking, exposing, etching, photoresist removal &rarr; Metal deposition &rarr; Photoresist deposition (Removal of excess metal), mask-4, removal.


## nMOS Inverter Fabrication {#nmos-inverter-fabrication}

-   Wafer diameter: 200-300mm
-   Inverter:
    Start with wafer, p-type &rarr; Grow \\(SiO\_{2}\\) via CVD (Thermal Oxidation) &rarr; Create n-well (Masking, HF Etching, PR Removal via Piranah [\\(H\_{2}O\_{2}+H\_{2}SO\_{4}\\)], Diffusion/Ion-Implantation, Oxide Removal) &rarr; Polysilicon Deposition and Gate formation (Self-align mask) &rarr; Oxide patterning in active area(S, D, PS) &rarr;  n-diffusion/implantation (also forms n+ region in the well for body contact) &rarr; Oxide stripping &rarr; Oxide deposition and patterning (for p-mos) &rarr; p-diffusion/implantation &rarr; MOS insulation (oxide deposition) &rarr; Opening creation (Removal) &rarr; Metal deposition
-   Shallow trench isolation : Etching and thick oxide deposition to prevent MOS interaction
-   In place of \\(SiO\_2\\), high-k dielectrics are being used for their high-epsilon values.
-   Layout Design (VLSI Design Flow): Functionality (VHDL) &rarr; Transform functional description into circuit &rarr; Take area and time constraints into account to estimate parasitics &rarr; Stick Diagram Layout &rarr; Mask layout Design &rarr; DRC Check (Design rules) &rarr; Extract parasitics from circuit &rarr; Simulation &rarr; Fabrication
-   Device Parasitics: \\(C\_{DB}\\), \\(C\_{GD}\\)
-   Extrinsic Parasitics: Due to interconnects
-   Design rules: Lambda based for scaling portability. Min. contact: 2&lambda;, Contact to active spacing: &lambda;, Contact to poly-spacing: 2&lambda;, n-well to active n-mos area: 9&lambda;, n-well to active overlap: 5&lambda;.
-   Stick Diagram: Combination of edges and nodes. Needed for sharing S&amp;D to reduce area via Euler's theorem.
-   Segregation coefficient:  Concentration of dopants in ingot / Concentration of dopants in liquid form; Useful in determining concentration of final wafer. \\(k\_{d}=\frac{C\_{s}}{C\_{l}}\\)


## Fabrication Layout Design {#fabrication-layout-design}

-   Micron rules: Specify absolute value of parameters, since not all dimensions scale linearly below 1um.
-   Stick Diagram: Combination of edges (transistor) and nodes (interconnection). Needed for orientation by defining sharing of S&amp;D to reduce area and parasitic capacitances via Euler's theorem.
-   Design Rules:
    1.  Minimum Width: Lithography, diffraction limit
    2.  Minimum Spacing: To prevent problems due to misalignment
    3.  Minimum Enclosure: To prevent problems due to misalignment
    4.  Minimum Extension: To prevent polysilicon misalignment problems
-   Euler's graph:
    1.  Generate p-net and n-net.
    2.  Find eulerian path, where a node can be traversed atmost twice but an edge only once.
    3.  Check if the polysilicon path generated can be used on the n-net.
-   In mos, source and drain are interchangable, which is not possible in bjt, hence mos allows for smaller footprint.
-   Analog layout techniques: The aim is to minimize offset and have high CMRR, (i.e. mos M_1 and M_2 are matched so low noise) which determine the minimum input signal that can be detected.
    1.  \\(R\_{g}<<\frac{1}{g\_{m}}\\)
    2.  To reduce this resistance, folder topology was introduced, two poly lines connected together represented a large L even though it wasn't actually large, hence W/L decreases.
    3.  Sometimes folder topology can result in some skewed layouts, so multi-fingered topology was introduced, where _n_ poly lines are connected together instead of just two.
    4.  By splitting the poly, it's resistance decreases but the capacitance associated with S/D perimeter increases.
    5.  For odd fingers, S/D perimeter capacitance,  \\(C\_{p}=\frac{N+1}{2}(2E+\frac{2W}{N})C\_{jsw}\\) (Side-wall/Fringe Capacitance)
    6.  Matching: Since fabrication is not isotropic, orientation of polysilicon needs to be the same throughout, even interconnects need to be of the same length.
    7.  Gate shadowing effect: Diffusion is not done vertically, there's an tilt of 7 degrees to avoid channeling (dopants penetrating deeper than needed through lattice spacing). This tilt causes asymmetry in source and drain diffusion extensions.
    8.  Dummy transistors: To avoid neighbour asymmetries (coupling) but since it causes an increase in area, it's not advised.


## Layout Techniques {#layout-techniques}

-   Interdigitated: Linear technique, alternate fingers of the two transistors but it still has mismatched envvironments. Useful when a treshold of mismatch is allowed.
-   Common Centroid: Place transistors such that transistors can either be placed in 1 or 2 directions.
-   Takes care of processing and surrounding errors.
-   Parasitics tells us about the speed of the propogating signal.
-   Device Parasitics: \\(C\_{sb}\\), depletion region; Can be reduced by junction sharing (Euler's graph, S/D Sharing). But as we increase the number of fingers, the overlap capacitance increases.


## Parasitics {#parasitics}

-   Major reasons for delay:
    1.  Internal parasitic
    2.  Interconnect Parasitic
    3.  Input capacitance of fan-out gates
-   Interconnect Capacitance: Model each interconnect as a Resistance and Capacitance combination.
-   Lumped RC Model: Model as a single RC combination
-   Distributed RC: Model as a combination of multiple RCs.
-   Transmission line model: Inductance is also introduced to account for magnetic coupling for long interconnects.
-   If \\(\tau\_{rise}>t\\), one can use lumped RC although even then distributed is preferred, but for \\(t>\tau\_{rise}\\) transmission model is preferred.
-   Due to scaling, gate delays are reducing but interconnect delays are increasing (chip size, and shrinking distance, fringing)
-   Inter module signals: Power (\\(V\_{dd}\\)), ground, clock.
-   Intra module connections: Since they run over small distances, they can be modeled via lumped or distributed.
-   Yuan and Trick Interconnect Capacitance Estimation: Accounts for all fringing etc.
-   Interconnect resistance estimation:
-   Calculation of Interconnect delay: For simple lumped RC: &tau; = 0.69RC, for distributed systems, we use elmore delay formula
-   Necessary conditions for elmore delay:
    1.  One input node
    2.  No loops
    3.  All capacitors connected to the ground
-


## Scaling and its effects {#scaling-and-its-effects}

-   Process Issues:
    1.  Shallow Trench: Signal coupling between transistors which can be avoided by increasing distance between them and adding \\(SiO\_2\\) between them. TCE (Temp. Coeff of Expansion) of Si and SiO_2 is different and on different expansion, due to stress mobility and therefore I-V characteristics changes, Can be avoided by using dummy fingers.
    2.  Well Proximity: Can be avoided using dummy.
    3.  Latchup:
