+++
title = "Analog and Digital VLSI Design"
author = ["Prashant Tak"]
draft = false
creator = "Emacs 27.2 (Org mode 9.5 + ox-hugo)"
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


## VLSI Design - An Overview {#vlsi-design-an-overview}

-   Moore's Law: Number of components (transistors) in ICs would double every two years.

{{< figure src="/ox-hugo/advd-moore-law.png" >}}

-
