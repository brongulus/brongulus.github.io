+++
title = "Analog and Digital VLSI Design"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 27.1 (Org mode 9.5 + ox-hugo)"
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
-   Why Si over Ge? Band gap Si>Ge, Ge can't be used in mass production due to lack of raw material also SiO\_2 is highly stable whereas GeO is soluble in water.
-   Getting that wafer:
    Sand &rarr; SiO\_2 &rarr; Metallurgical Grade Si (99.9% Pure) &rarr; CZ Chamber (1000^o C) &rarr; Seed Crystal + Molten Si &rarr; Si crystal ingot &rarr; Diamond saw &rarr; Polishing &rarr; Silican Wafer
-   Dopants are introduced in the CZ chamber via _diffusion/ion implantation_, n-type: B (Pentavalent), p-type: P(Trivalent)
-   Diffusion:
    Temperature is around 650 C, Carrier made of quartz, Dopant in either crystal or powdered form, preheating temperature slightly lower than furnace, carrier gas carries the dopant vapours onto the silicon wafer by getting into the vacant sites of lattice defects and when they move from interstitional locations to lattice positions, doping is complete.
-   Fick's Law: Determines the amount of dopant required, diffusion temperature and the duration of the diffusion.
-   Ion Implantation:
    Source of the dopants are in ionic (charged) form, so an ion source releases a beam of ions which is columated by lenses to a small spot size called aperture, this accelerated beam of ions hits the silicon surface and the bombardment results in dislodging of Si atoms from the lattice, and the broken bonds are healed via _annealing_ (heating of wafer post-implantation).
